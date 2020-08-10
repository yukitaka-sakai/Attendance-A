class AttendancesController < ApplicationController

  def update
    @user = User.find(params[:user_id])
    @attendance = Attendance.find(params[:id])
    # 出勤時間が未登録である事を判定する
    if @attendance.started_at.nil?
      if @attendance.update_attributes(started_at: Time.current.change(sec: 0))
        flash[:info] = "goodmorningですな"
      else
        flash[:danger] = "登録失敗やり直せ！"
      end
    end
    redirect_to @user
  end
end
