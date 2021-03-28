class AttendancesController < ApplicationController
  before_action :set_user, only: [:edit_one_month, :update_one_month, :approval_log]
  before_action :logged_in_user, only: [:update, :edit_ont_month, :import, :update_one_month, :approval_log]
  before_action :set_one_month, only: [:edit_one_month]
  before_action :edit_one_month_approval, only: :edit_approval_page
  
  UPDATE_ERROR_MSG = "勤怠登録に失敗しました。やり直して下さい。"
  
  def edit_attendance_system
  end

# 出社・退社時間の入力
  def update
    @user = User.find(params[:user_id])
    @attendance = Attendance.find(params[:id])
    if @attendance.started_at.nil?
      @attendance.edit_started_at = @attendance.started_at
      @attendance.log_started_at = @attendance.started_at
      if @attendance.update_attributes(started_at: Time.current.change(sec: 0),
                                        edit_started_at: Time.current.change(sec: 0),
                                        log_started_at: Time.current.change(sec: 0))
        flash[:info] = "おはようございます。"
      else
        flash[:danger] = UPDATE_ERROR_MSG
      end
    elsif @attendance.finished_at.nil?
      @attendance.edit_finished_at = @attendance.finished_at
      @attendance.log_finished_at = @attendance.finished_at
      if @attendance.update_attributes(finished_at: Time.current.change(sec: 0),
                                        edit_finished_at: Time.current.change(sec: 0),
                                        log_finished_at: Time.current.change(sec: 0))
        flash[:info] = "お疲れ様でした。"
      else
        flash[:danger] = UPDATE_ERROR_MSG
      end
        @attendance.edit_next_day = @attendance.next_day if @attendance.started_at.present? || @attendance.finished_at
    end
    redirect_to @user
  end
  
  # 勤怠編集画面を表示させる（するときの処理）
  def edit_one_month
    @superiors = User.where(superior: true).where.not(id: @user.id).select(:name)
  end
  
  # 勤怠情報の編集申請（するときの処理）
  def update_one_month
    n = 0
    ActiveRecord::Base.transaction do
      attendances_params.each do |id, item| 
        attendance = Attendance.find(id)
        if item[:application_superior_name].present? 
          if item[:edit_started_at].blank?
            flash[:danger] = "出社時間の入力が必要です。"
            redirect_to attendances_edit_one_month_user_url(@user) and return
          elsif item[:edit_finished_at].blank? 
            flash[:danger] = "退社時間の入力が必要です。"
            redirect_to attendances_edit_one_month_user_url(@user) and return
          elsif (item[:edit_next_day] =="0") && (item[:edit_started_at] > item[:edit_finished_at])
            flash[:danger] = "出社時間より早い退社時間はできません。"
            redirect_to attendances_edit_one_month_user_url(@user) and return
          elsif item[:edit_note].blank? 
            flash[:danger] = "備考へ内容を記入してください。"
            redirect_to attendances_edit_one_month_user_url(@user) and return #空の項目はないか
          end
        if attendance.edit_status == "承認"
          item[:edit_status] = "申請中"
          item[:before_started_at] = attendance.started_at
          item[:before_finished_at] = attendance.finished_at
          item[:before_edit_note] = attendance.note
          item[:note] = item[:edit_note]
          item[:before_application_superior_name] = attendance.application_superior_name
          # binding.pry
          attendance.update_attributes!(item)
          n += 1
        elsif attendance.edit_status == "否認"
          item[:edit_status] = "申請中"
          item[:before_started_at] = attendance.started_at
          item[:before_finished_at] = attendance.finished_at
          item[:note] = item[:edit_note]
          attendance.update_attributes!(item)
          n += 1
        else
          item[:edit_status] = "申請中"
          item[:log_started_at] = attendance.started_at if attendance.started_at.blank?
          item[:log_finished_at] = attendance.finished_at if attendance.finished_at.blank?
          item[:before_started_at] = attendance.started_at
          item[:before_finished_at] = attendance.finished_at
          item[:note] = item[:edit_note]
          attendance.update_attributes!(item)
          n += 1
        end
          
        # elsif item[:edit_started_at].present? || item[:edit_finished_at].present? || item[:edit_note].present?
        #   flash[:danger] = "上長の入力が必要です。"
        #   redirect_to attendances_edit_one_month_user_url(@user) and return
        end
      end #do
    end #do
    flash[:success] = "勤務変更を#{n}件申請しました。"
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
  
  def update_overtime_request #一件のみ保存する
    @user = User.find(params[:user_id])
    @attendance = Attendance.find(params[:id])
        # binding.pry
    # t = Time.current
    # @time_current = t.strftime("%H:%M")
    # @next_day_judge1 = params[:attendance][:overtime_finished_at] < @time_current
    # @next_day_judge2 = format("%.2f",((@user.designated_work_end_time.hour + (@user.designated_work_end_time.min)/60.0))) > params[:attendance][:overtime_finished_at]
    # if @next_day_judge1 == true && @attendance.worked_on == Date.today && params[:attendance][:overtime_next_day] == "0"
    #   flash[:danger] = "翌日になる場合は、翌日にチェックを入れてください。"
    #   redirect_to @user and return
    # elsif @next_day_judge2 == true && @attendance.started_at == nil && @attendance.finished_at == nil && params[:attendance][:overtime_next_day] == "0"
    #   flash[:danger] = "翌日になる場合は、翌日にチェックを入れてください。"
    #   redirect_to @user and return
    # else
      if params[:attendance][:overtime_finished_at].present?
        params[:attendance][:overtime_status] = "申請中" 
        if @attendance.update_attributes!(overtime_params)
          flash[:success] = "残業申請を行いました。"
          redirect_to @user and return
        else
          flash[:danger] = "申請に失敗しました。"
          redirect_to @user and return
        end
      end
    # end
  end
  
  def approval_log
    if params["edit_approval_date(1i)"].present?
      @search_date = Date.new(params["edit_approval_date(1i)"].to_i,params["edit_approval_date(2i)"].to_i,params["edit_approval_date(3i)"].to_i)
      @last_day = @search_date.end_of_month
    end
    @attendances = @user.attendances.where(log_edit_status: "承認", worked_on: @search_date..@last_day).order(:worked_on)
  end
    
  private
    # 1ヶ月分の勤怠情報を扱います。
    def attendances_params
      params.require(:user).permit(attendances: [:started_at, :finished_at, :next_day, :note, :before_started_at, :before_started_at,
                            :before_edit_note, :edit_started_at, :edit_finished_at, :edit_next_day, :edit_note, :edit_status, 
                            :application_superior, :application_superior_name, :edit_confirmation])[:attendances]
    end
    
    def overtime_params
      params.require(:attendance).permit(:overtime_finished_at, :overtime_next_day,
                            :overtime_note, :overtime_status, 
                            :overtime_application_superior_name)
    end
    
    def approval_one_month_params
      params.require(:attendance).permit(:application_onemonth_superior_name, :one_month_status)
    end
    
end
