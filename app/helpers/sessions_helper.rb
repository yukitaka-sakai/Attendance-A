module SessionsHelper
  
  # 引数に渡されたユーザーオブジェクトでログインする。
  def log_in(user)
    # ブラウザ内にある一時的cookiesに暗号化済みのuser.idが自動で生成される。
    session[:user_id] = user.id
  end
  
  # 永続的セッションを記憶する（Userモデルを参照する）
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end
  
  def forget(user)
    user.forget #Userモデルを参照する
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end
  
  def log_out
    forget(current_user)
    session.delete(:user_id) # 一時的セッションのユーザーを消す
    @current_user = nil # current_userに何もないを代入
  end
  
  def current_user
    # もし一時的セッションの中身が何もなければ、
    if (user_id = session[:user_id])
      # User.find_byを代入する。それ以外は中身があるから@current_userを返す。
      @current_user = @current_user || User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end
  
  # 現在ログイン中のユーザーがいればtrue、そうでなければfalseを返す
  def logged_in?
    !current_user.nil?
  end
end
