class SessionsController < ApplicationController
  
  def new
  end
  
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      # redirect_to 
    else
      flash.now[:danger] = "だめ"
    render :new
    end
  end
end
