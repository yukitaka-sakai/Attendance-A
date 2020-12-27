class AttendancesController < ApplicationController
  before_action :set_user, only: [:edit_one_month, :update_one_month]
  before_action :logged_in_user, only: [:updafte, :edit_ont_month, :import, :update_one_month]
  before_action :set_one_month, only: [:edit_one_month]
  before_action :edit_one_month_approval, only: :edit_approval_page
  
  
  UPDATE_ERROR_MSG = "勤怠登録に失敗しました。やり直して下さい。"

# 出社・退社時間の入力
  def update
    @user = User.find(params[:user_id])
    @attendance = Attendance.find(params[:id])
    # 出勤時間が未登録である事を判定する
    if @attendance.started_at.nil?
    # 出勤データが入ったら編集用出勤カラムにも同じ内容を代入する。
       @attendance.edit_started_at = @attendance.started_at
      if @attendance.update_attributes(started_at: Time.current.change(sec: 0), edit_started_at: Time.current.change(sec: 0))
        flash[:info] = "goodmorning"
      else
        flash[:danger] = UPDATE_ERROR_MSG
      end
    elsif @attendance.finished_at.nil?
          @attendance.edit_finished_at = @attendance.finished_at
      if @attendance.update_attributes(finished_at: Time.current.change(sec: 0), edit_finished_at: Time.current.change(sec: 0))
        flash[:info] = "おつかれ"
      else
        flash[:danger] = UPDATE_ERROR_MSG
      end
      # debugger
         @attendance.edit_next_day = @attendance.next_day if @attendance.started_at.present? || @attendance.finished_at
    end
    redirect_to @user
  end
  
#　勤怠編集機能

  # 勤怠編集画面を表示させる（するときの処理）
  def edit_one_month
    # ユーザーモデルのsuperiorが入力され、自分のID以外の名前を@superiorsに代入する。
    @superiors = User.where(superior: true).where.not(id: @user.id).select(:name)
  end
  
  # 勤怠情報の編集申請（するときの処理）
  def update_one_month
    ActiveRecord::Base.transaction do
      attendances_params.each do |id, item| # ストロングパラメータの内容に基づいて　idとitemに対して繰り返す。
        attendance = Attendance.find(id) # before_actionのset_one_monthからattendanceのidを代入する
        if item[:application_superior_name].present? #上長が選択されているなら
          if item[:edit_started_at].blank? # 編集画面の　出社時間　がないなら
            flash[:danger] = "出社時間の入力がないよ"
            redirect_to attendances_edit_one_month_user_url(date: params[:date]) and return
          elsif item[:edit_finished_at].blank? # ���集画面の　退社時間　がないなら
            flash[:danger] = "退社時間がないよ"
            redirect_to attendances_edit_one_month_user_url(date: params[:date]) and return
      # 編集画面の　翌日　且つ　出社時間より退社時間が早いなら
          elsif (item[:edit_next_day] =="0") && (item[:edit_started_at] > item[:edit_finished_at])
            flash[:danger] = "出社時間より早い退社時間はできません。"
            redirect_to attendances_edit_one_month_user_url(date: params[:date]) and return
          elsif item[:note].blank? # 編集画面の　備考　がないなら
            flash[:danger] = "備考がないよ"
            redirect_to attendances_edit_one_month_user_url(date: params[:date]) and return
          end
          item[:edit_status] = "申請中"
          item[:edit_confirmation] = nil
          attendance.update_attributes!(item)
        end
      end
    end
    flash[:success] = "勤怠変更申請を送信しました。"
    redirect_to user_url(date: params[:date])
  rescue ActiveRecord::RecordInvalid
    flash[:danger] = "無効な入力データがあった為、更新をキャンセルしました。"
    redirect_to attendances_edit_one_month_user_url(date: params[:date])
  end
  
  def overtime_request
    @user = User.find(params[:user_id])
    @attendance = Attendance.find(params[:id])
    @superiors = User.where(superior: true).where.not(id: @user.id).select(:name)
    
  end
  
  def update_overtime_request
    @user = User.find(params[:user_id])
    @attendance = Attendance.find(params[:id])
    if params[:attendance][:overtime_finished_at].present?
      params[:attendance][:overtime_status] = "申請中" 
      if @attendance.update_attributes(overtime_params)
        flash[:success] = "残業申請を行いました。"
        redirect_to @user
      else
        flash[:danger] = "申請に失敗しました。"
        redirect_to @user
      end
    end
  end
  

  private
    # 1ヶ月分の勤怠情報を扱います。
    def attendances_params
      params.require(:user).permit(attendances: [:started_at, :finished_at, :next_day, :note,
                            :edit_started_at, :edit_finished_at, :edit_next_day, :edit_status, 
                            :application_superior, :application_superior_name, :edit_confirmation])[:attendances]
    end
    
    def overtime_params
      params.require(:attendance).permit(:overtime_finished_at, :overtime_next_day,
                            :overtime_note, :overtimes, :overtime_status, 
                            :overtime_confirmation, :application_superior_name)
      # debugger
    end
end
