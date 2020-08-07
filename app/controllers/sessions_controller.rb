class SessionsController < ApplicationController
  
  def new
  end
  
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in user
      redirect_to user
    else
      flash.now[:danger] = "だめ"
    render :new
    end
  end
  
  def destroy
    log_out
    flash[:success] = "ログアウトしたよ"
    redirect_to root_url
  end
end
