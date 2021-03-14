class UsersController < ApplicationController
  before_action :set_user,       only: [:show, :edit, :update, :destroy, :approval_show]
  before_action :logged_in_user, only: [:index, :show, :edit, :update, :destroy, :approval_show]
  before_action :correct_user,   only: [:show, :edit, :update, :destroy]
  before_action :admin_user,     only: [:destroy, :edit, :update, :index, :employee_index]
  before_action :set_one_month,  only: [:show, :approval_show]
  before_action :set_month,  only: :show
  
# ユーザーの勤怠画面へ遷移（するときの処理）
  def show
    @superiors = User.where(superior: true).where.not(id: @user.id).select(:name)
    @worked_sum = @attendances.where.not(started_at: nil).count
    @approval_edit_sum = Attendance.where(application_superior_name: @user.name, edit_status: "申請中").count
    @approval_overtime_sum = Attendance.where(application_superior_name: @user.name, overtime_status: "申請中").count
    @approval_onemonth_sum = Report.where(application_onemonth_superior_name: @user.name, approval_month_status: "申請中").count
# CSV出力
    respond_to do |format| 
      format.html 
      format.csv do
          send_data render_to_string, 
          filename: "#{@user.name}-#{@first_day.year}_#{@first_day.month}.csv", type: :csv #csv用の処理を書く
      end
    end
  end
  
# ユーザーの一覧ページへ画面遷移（するときの処理）
  def index
    @users = User.all.where.not(admin: true ).paginate(page: params[:page]).search(params[:search])
    @offices = Office.all
  end
  
  def employee_index
    # @attendances = Attendance.where(finished_at: nil).where.not(started_at: nil).order(:user_id)
    @users = User.includes(:attendances).references(:attendances).
    where('attendances.started_at IS NOT NULL').
    where('attendances.finished_at IS NULL')
  end
  
# CSVファイルインポート機能
  def import
    if params[:csv_file].blank?
      flash[:danger] = "インポート するCSVファイルを選択してください。"
      redirect_to users_url
    else
      num = User.import(params[:csv_file])  # fileはtmpに自動で一時保存される
      if num > 0
        flash[:success] = "#{num.to_s}件のユーザー情報を追加しました。"
        redirect_to users_url
      else
        flash[:danger] = "読み込みエラーが発生しました。"
        redirect_to users_url
      end
    end
  end
  
# ユーザー新規登録画面へ遷移（するときの処理）
  def new
    @user = User.new
  end
  
# ユーザー新規登録の保存処理
  def create
    @office = Office.find_by(params[:user][:office_id])
    @user = User.new(user_params) #フォームから送られて来た新しいパラメーターを＠userに代入
    if @user.save #  @userの登録に成功したら
      if @user.affiliation == "総務部"
        @user.uid = @office.office_number.to_s+ "-" + (@user.id + 1000).to_s
        @user.save
      elsif @user.affiliation == "事務部"
        @user.uid = @office.office_number.to_s+ "-" + (@user.id + 2000).to_s
        @user.save
      elsif @user.affiliation == "人事部"
        @user.uid = @office.office_number.to_s+ "-" + (@user.id + 3000).to_s
        @user.save
      elsif @user.affiliation == "窓際部"
        @user.uid = @office.office_number.to_s+ "-" + (@user.id + 4000).to_s
        @user.save
      end
    
      log_in @user #保存成功後、ログインする
      flash[:success] = '新規作成に成功しました。' # 成功メッセージを出す
      redirect_to @user # redirect_to user_url(@user)をシンプルに記述　＞showへ遷移
    else
      render :new # 失敗したらnewに戻る
    end
  end
  
# ユーザー情報の編集画面へ遷移（するときの処理）
  def edit
    @offices = Office.all
  end
  
# ユーザ情報の更新処理
  def update
    if @user.update_attributes(user_params)
      flash[:success] = "更新成功"
      redirect_to users_url
    else
      render :edit
    end
  end
  
# ユーザー情報の削除処理
  def destroy
    @user.destroy
    flash[:success] = "#{@user.name}のデータを削除しました。"
    redirect_to users_url
  end

# 残業申請確認モーダルへ遷移（するときの処理）
  def approval_overtime_request
    # ログインしているユーザーを特定する。
    @user = User.find(params[:user_id])
    # Attendanceテーブルから特定された上長名がカラムにデータを持つ勤怠データを＠attendanceに代入する。
    @attendances = Attendance.where(application_superior_name: @user.name, overtime_status: "申請中").order(user_id: "ASC", worked_on: "ASC").group_by(&:user_id)
  end
  
  def update_approval_overtime_request
    ActiveRecord::Base.transaction do
      overtime_request_params.each do |id, item|
        if item[:overtime_confirmation] == "1"
          attendance = Attendance.find(id)
          if item[:overtime_status] == "なし"
            item[:next_day] = nil
            item[:note] = nil
            item[:overtime_status] = nil
            item[:overtime_confirmation] = nil
            item[:application_superior_name] = nil
            flash[:danger] = "残業申請を削除しました。"
          elsif item[:overtime_status] == "承認"
            item[:next_day] = item[:overtime_next_day]
            item[:overtime_confirmation] = "残業申請承認済"
            flash[:success] = "残業申請を承認しました。"
          elsif item[:overtime_status] == "否認"
            item[:next_day] = nil
            item[:overtime_confirmation] = "残業申請否認"
            flash[:danger] = "残業申請は否認されました。"
          end
          attendance.update_attributes!(item)
        else
          item[:overtime_status] = nil
        end
      end
    end
    redirect_to user_url(params[:user_id])
  rescue ActiveRecord::RecordInvalid # トランザクションによるエラーの分岐です。
    flash[:danger] = "無効な入力データがあった為、更新をキャンセルしました。"
    redirect_to user_url(params[:user_id])
  end

  # 勤怠情報確認モーダルへ遷移（するときの処理）
  def approval_edit_month
    # ログインしているユーザーを特定する。
    @user = User.find(params[:user_id])
    # Attendanceテーブルから特定された上長名がカラムにデータを持つ勤怠データを＠attendanceに代入する。
    @attendances = Attendance.where(application_superior_name: @user.name, edit_status: "申請中").order(user_id: "ASC", worked_on: "ASC").group_by(&:user_id)
  end
  
  def update_approval_edit_month
    ActiveRecord::Base.transaction do
      edit_approval_params.each do |id, item|
        if item[:edit_confirmation] == "1" # 変更check boxが選択されているなら。
          attendance = Attendance.find(id) # attendanceにAttendanceテーブルのIDを代入する
          if item[:edit_status] == "なし" # 勤怠申請自体が無かったことにする。
            # attendance.edit_started_at = nil 
            # attendance.edit_finished_at = nil
            attendance.next_day = nil
            attendance.note = nil
            item[:edit_status] = nil
            item[:edit_confirmation] = nil
            attendance.application_superior_name = nil
            flash[:danger] = "勤務変更を削除しました。"
          elsif item[:edit_status] == "承認"
            item[:before_started_at] = attendance.started_at
            item[:before_finished_at] = attendance.finished_at
            attendance.started_at = attendance.edit_started_at # 承認なら変更時間を勤怠時間に代入する。
            attendance.finished_at = attendance.edit_finished_at
            attendance.next_day = item[:edit_next_day]
            item[:edit_approval_date] = Date.current
            item[:edit_confirmation] = "編集承認済"
            flash[:success] = "勤怠情報を承認しました。"
          elsif item[:edit_status] == "否認"
            attendance.edit_started_at = nil # 否認なら変更時間を削除し、勤怠編集否認のメッセージ
            attendance.edit_finished_at = nil
            attendance.next_day = nil
            item[:edit_confirmation] = "勤怠編集承否認"
            flash[:danger] = "勤怠情報を否認しました。"
          end
            attendance.update_attributes!(item)
        else
          item[:edit_status] = nil 
        end
      end
    end
    redirect_to user_url(params[:user_id])
  rescue ActiveRecord::RecordInvalid # トランザクションによるエラーの分岐です。
    flash[:danger] = "無効な入力データがあった為、更新をキャンセルしました。"
    redirect_to user_url(params[:user_id])
  end
  
  def approval_one_month
    # ログインしているユーザーを特定する。
    @user = User.find(params[:user_id])
    # Attendanceテーブルから特定された上長名がカラムにデータを持つ勤怠データを＠attendanceに代入する。
    @attendances = Attendance.where(application_superior_name: @user.name, edit_status: "申請中").order(user_id: "ASC", worked_on: "ASC").group_by(&:user_id)
  end
  
  def update_approval_one_month
  end
  
  def approval_show
    @worked_sum = @attendances.where.not(started_at: nil).count
  end
  
  def approval_month_report
    @user = User.find(params[:user_id])
    @reports = Report.where(application_onemonth_superior_name: @user.name, approval_month_status: "申請中").order(user_id: "ASC", report_month: "ASC").group_by(&:user_id)
    # @superiors = User.where(superior: true).where.not(id: @user.id).select(:name)
  end
  
  def update_approval_month_report
    ActiveRecord::Base.transaction do
      approval_month_report_params.each do |id, item|
        if item[:report_confirmation] == "1"
          report = Report.find(id)
          if item[:approval_month_status] == "なし"
            item[:approval_month_status] = nil
            item[:report_confirmation] = nil
            item[:application_onemonth_superior_name] = nil
            flash[:danger] = "1ヶ月の勤務申請を削除しました。"
          elsif item[:approval_month_status] == "承認"
            item[:report_confirmation] = "1ヶ月の勤務申請承認済"
            flash[:success] = "1ヶ月の勤務申請を承認しました。"
          elsif item[:approval_month_status] == "否認"
            item[:report_confirmation] = "1ヶ月の勤務申請否認"
            flash[:danger] = "1ヶ月の勤務申請は否認されました。"
          elsif item[:approval_month_status] == "申請中"
            item[:report_confirmation] = nil
            flash[:danger] = "変更が選択されませんでした。"
          end
          report.update_attributes!(item)
        else
          item[:approval_month_status] = nil
        end
      end
    end
    redirect_to user_url(params[:user_id])
  rescue ActiveRecord::RecordInvalid # トランザクションによるエラーの分岐です。
    flash[:danger] = "無効な入力データがあった為、更新をキャンセルしました。"
    redirect_to user_url(params[:user_id])
  end
  
  private
  
# ストロングパラメーター  
    def user_params # ユーザーのパラメーターは
      # requireメソッドでオブジェクト名を定める。permitでキーを指定する。
      params.require(:user).permit(:name, :email, :affiliation, :basic_work_time, :designated_work_start_time,
                                   :designated_work_end_time, :password, :password_confirmation, :office_id)
    end
    
    def edit_approval_params
      params.require(:user)
      .permit(attendances: [:started_at, :finished_at, 
                            :edit_started_at, :edit_finished_at, :next_day, :edit_next_day, :note,
                            :edit_status, :edit_confirmation, :edit_approval_date,
                            :before_started_at, :before_finished_at])[:attendances]
    end
    
    def overtime_request_params
      params.require(:user)
      .permit(attendances: [:overtime_finished_at, :overtime_next_day, :overtime_confirmation,
                            :overtime_status, :next_day, :note, :application_superior_name])[:attendances]
    end
    
    def approval_month_report_params
      # debugger
      params.require(:user)
      .permit(reports: [:application_onemonth_superior_name, :approval_month_status, :report_month,
                        :report_confirmation])[:reports]
    end    
end