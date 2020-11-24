class UsersController < ApplicationController
  before_action :set_user,       only: [:show, :edit, :update, :destroy, :approval_show]
  before_action :logged_in_user, only: [:index, :show, :edit, :update, :destroy, :approval_show]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: [:destroy, :edit, :update]
  before_action :set_one_month,  only: [:show, :approval_show]
  
# ユーザーの勤怠画面へ遷移（するときの処理）
  def show
    @superiors = User.where(superior: true).select(:name)
    @worked_sum = @attendances.where.not(started_at: nil).count
    @approval_edit_sum = Attendance.where(application_superior_name: @user.name, edit_status: "申請中").count
    @approval_overtime_sum = Attendance.where(application_superior_name: @user.name, overtime_status: "申請中").count
# debugger
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
    @users = User.paginate(page: params[:page]).search(params[:search])
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
    @user = User.new(user_params) #フォームから送られて来た新しいパラメーターを＠userに代入
    if @user.save #  @userの登録に成功したら
      log_in @user #保存成功後、ログインする
      flash[:success] = '新規作成に成功しました。' # 成功メッセージを出す
      redirect_to @user # redirect_to user_url(@user)をシンプルに記述　＞showへ遷移
    else
      render :new # 失敗したらnewに戻る
    end
  end
  
# ユーザー情報の編集画面へ遷移（するときの処理）
  def edit
  end
  
# ユーザー情報の更新処理
  def update
    if @user.update_attributes(user_params)
      flash[:success] = "更新成功"
      redirect_to @user
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
  def approval_overtime
    # ログインしているユーザーを特定する。
    @user = User.find(params[:user_id])
    # Attendanceテーブルから特定された上長名がカラムにデータを持つ勤怠データを＠attendanceに代入する。
    @attendances = Attendance.where(application_superior_name: @user.name, edit_status: "申請中").order(user_id: "ASC", worked_on: "ASC").group_by(&:user_id)
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
      if item[:edit_confirmation].present? # 変更check boxが選択されているなら。
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
          attendance.started_at = attendance.edit_started_at # 承認なら変更時間を勤怠時間に代入する。
          attendance.finished_at = attendance.edit_finished_at
          attendance.next_day = item[:edit_next_day]
          item[:edit_confirmation] = "編集承認済"
          flash[:success] = "勤怠情報を承認しました。"
        elsif item[:edit_status] == "否認"
          attendance.edit_started_at = nil # 否認なら変更時間を削除し、勤怠編集否認のメッセージ
          attendance.edit_finished_at = nil
          attendance.next_day = nil
          item[:edit_confirmation] = "勤怠編集承否認"
          flash[:danger] = "勤怠情報を否認しました。"
        end
        # debugger
          attendance.update_attributes!(item)
      else
        item[:edit_status] = nil 
      end
    end
  end
  # debugger
    redirect_to user_url(params[:user_id])
  rescue ActiveRecord::RecordInvalid # トランザクションによるエラーの分岐です。
    flash[:danger] = "無効な入力データがあった為、更新をキャンセルしました。"
    redirect_to user_url(params[:user_id])
  end
  
  def approval_show
    @user = User.find(params[:id])
    @worked_sum = @attendances.where.not(started_at: nil).count
  end
    
  
  private
  
# ストロングパラメーター  
    def user_params # ユーザーのパラメーターは
      # requireメソッドでオブジェクト名を定める。permitでキーを指定する。
      params.require(:user).permit(:name, :email, :affiliation, :basic_work_time, :designated_work_start_time, :designated_work_end_time, :password, :password_confirmation)
    end
    
    def edit_approval_params
      params.require(:user)
      .permit(attendances: [:started_at, :finished_at, 
                            :edit_started_at, :edit_finished_at, :next_day, :edit_next_day, :note,
                            :edit_status, :edit_confirmation])[:attendances]
    end
end