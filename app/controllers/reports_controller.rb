class ReportsController < ApplicationController
  
  def update
    @user = User.find(params[:user_id])
    @attendance = Attendance.find(params[:id])
    @report = Report.find(params[:user_id])
    # params[:approval_month_status] = "true" if params[:application_onemonth_superior_name].present?
    if params[:date] <= Date.current.to_s && params[:application_onemonth_superior_name].present?
      binding.pry
      @report = @user.reports.create!(approval_onemonth_params)
      flash[:info] = "記録"
      redirect_to @user
    else
      flash[:danger] = "失敗"
      redirect_to @user
    end
  end

  private
  
    def approval_onemonth_params
      params.permit(:application_onemonth_superior_name, :approval_month_status)
    end
end
