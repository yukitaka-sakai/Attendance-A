class UsersController < ApplicationController
  
  def show # 送られてきたパラメータ（id）と同じidを持つレコードをuserモデルから探し@userに代入
    @user =User.find(params[:id])
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to @user
      flash[:success] = '新規作成に成功しました。'
    else
      render :new
    end
  end
  
  private
  
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end
