class AttendancesController < ApplicationController
  before_action :set_user, only: [:edit_one_month, :update_one_month]
  before_action :logged_in_user, only: [:updafte, :edit_ont_month, :import, :update_one_month]
  before_action :set_one_month, only: :edit_one_month
  before_action :edit_one_month_approval, only: :edit_approval_page
  
  
  UPDATE_ERROR_MSG = "勤怠登録に失敗しました。やり直して下さい。"

# 出社・退社時間の入力
  def update
    @user = User.find(params[:user_id])
    @attendance = Attendance.find(params[:id])
    # 出勤時間が未登録である事を判定する
    if @attendance.started_at.nil?
       @attendance.edit_started_at = @attendance.started_at
      if @attendance.update_attributes(started_at: Time.current.change(sec: 0), edit_started_at: Time.current.change(sec: 0))
        flash[:info] = "goodmorningですな"
      else
        flash[:danger] = UPDATE_ERROR_MSG
      end
    elsif @attendance.finished_at.nil?
          @attendance.edit_finished_at = @attendance.finished_at
      if @attendance.update_attributes(finished_at: Time.current.change(sec: 0), edit_finished_at: Time.current.change(sec: 0))
        flash[:info] = "おつかレ"
      else
        flash[:danger] = UPDATE_ERROR_MSG
      end
         @attendance.edit_next_day = @attendance.next_day if @attendance.started_at.presente? || @attendance.finished_at
      # debugger
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
    # トランザクションを開始する
    ActiveRecord::Base.transaction do
      # ストロングパラメータの内容に基づいて　idとitemに対して繰り返す。
      attendances_params.each do |id, item|
      # before_actionのset_one_monthからattendanceのidを代入する
        attendance = Attendance.find(id)
      #上長が選択されているなら
        if item[:application_superior_name].present?
      # 編集画面の　出社時間　がないなら
          if item[:edit_started_at].blank?
            flash[:danger] = "出社時間の入力がないよ"
            redirect_to attendances_edit_one_month_user_url(date: params[:date]) and return
      # 編集画面の　退社時間　がないなら
          elsif item[:edit_finished_at].blank?
            flash[:danger] = "退社時間がないよ"
            redirect_to attendances_edit_one_month_user_url(date: params[:date]) and return
      # 編集画面の　備考　がないなら
          elsif item[:edit_next_day] == "0" && (item[:edit_started_at] > item[:edit_finished_at])
            flash[:danger] = "出社時間より早い退社時間はできません。"
            redirect_to attendances_edit_one_month_user_url(date: params[:date]) and return
      # 編集画面の　備考　がないなら
          elsif item[:note].blank?
            flash[:danger] = "備考がないよ"
            redirect_to attendances_edit_one_month_user_url(date: params[:date]) and return
          end
          attendance.update_attributes!(item)
        end
      end
    end
    flash[:success] = "1ヶ月分の勤怠情報を更新しました。"
    # debugger
    redirect_to user_url(date: params[:date])
  rescue ActiveRecord::RecordInvalid
    flash[:danger] = "無効な入力データがあった為、更新をキャンセルしました。"
    
  
    redirect_to attendances_edit_one_month_user_url(date: params[:date])
  end
    
  private
    # 1ヶ月分の勤怠情報を扱います。
    def attendances_params
      params.require(:user).permit(attendances: [:started_at, :finished_at, :edit_started_at, :edit_finished_at, :note, :next_day, :edit_next_day, :application_superior_name,])[:attendances]
    end
end
