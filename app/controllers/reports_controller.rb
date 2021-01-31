class ReportsController < ApplicationController

  def update
    @user = User.find(params[:user_id])
    @report = Report.find(params[:id])
    # reportが未登録を判別
    if @report.update_attributes(approval_onemonth_params)
      flash[:info] = "記録"
      redirect_to @user
    else
      flash[:danger] = "失敗"
      redirect_to @user
    end
  end
  

    
  private
  
    def approval_onemonth_params
      # debugger
      params.require(:report).permit(:application_onemonth_superior_name, :approval_month_status, :report_month)
    end
    

end
