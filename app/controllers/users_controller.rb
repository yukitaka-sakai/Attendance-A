class UsersController < ApplicationController
  before_action :set_user,       only: [:show, :edit, :update]
  before_action :logged_in_user, only: [:show, :edit, :update]
  before_action :correct_user,   only: [:edit, :update]
  
  def show # 送られてきたパラメータ（id）と同じidを持つレコードをuserモデルから探し@userに代入
    @user = User.find(params[:id])
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params) #userモデルの新しいパラメーターを＠userに代入
    if @user.save #  @userの登録に成功したら
      log_in @user #保存成功後、ログインする
      flash[:success] = '新規作成に成功しました。' # 成功メッセージを出す
      redirect_to @user # redirect_to user_url(@user)をシンプルに記述　＞showへ遷移
    else
      render :new # 失敗したらnewに戻る
    end
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "更新成功"
      redirect_to @user
    else
      render :edit
    end
  end
  
  private
  
    def user_params # ストロングパラメーター　ユーザーのパラメーターは
      # requireメソッドでオブジェクト名を定める。permitでキーを指定する。
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
    
    def set_user
      @user = User.find(params[:id])
    end
    
    def logged_in_user
      unless logged_in? # loginしていなかったら
        store_location # アクセスしようとしたURLを記憶する
        flash[:danger] = "ログインしてください"
        redirect_to login_url
      end
    end
    
    def correct_user
      @user = User.find(params[:id])
      redirect_to root_url unless current_user?(@user) #current_userがuserと違うならトップページに戻る
    end
end
