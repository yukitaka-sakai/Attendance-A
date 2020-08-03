class UsersController < ApplicationController
  
  def show # 送られてきたパラメータ（id）と同じidを持つレコードをuserモデルから探し@userに代入
    @user =User.find(params[:id])
  end
  
  def new
  end
end
