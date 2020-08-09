class SessionsController < ApplicationController
  
  def new
  end
  
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in user
      params[:session][:remember_me] == "1" ? remember(user) : forget(user)
      if user.admin?
        redirect_back_or users_path
      else
        redirect_back_or user
      end
    else
      flash.now[:danger] = "だめ"
    render :new
    end
  end
  
  def destroy
    log_out if logged_in?
    flash[:success] = "ログアウトしたよ"
    redirect_to root_url
  end
end
