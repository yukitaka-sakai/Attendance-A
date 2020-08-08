class UsersController < ApplicationController
  
  def show # 送られてきたパラメータ（id）と同じidを持つレコードをuserモデルから探し@userに代入
    @user =User.find(params[:id])
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
  
  private
  
    def user_params # ストロングパラメーター　ユーザーのパラメーターは
    　# requireメソッドでオブジェクト名を定める。permitでキーを指定する。
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end
