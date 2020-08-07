module SessionsHelper
  
  # 引数に渡されたユーザーオブジェクトでログインする。
  def log_in(user)
    # ブラウザ内にある一時的cookiesに暗号化済みのuser.idが自動で生成される。
    session[:user_id] = user.id
  end
  
  def log_out
    session.delete(:user_id) # 一時的セッションのユーザーを消す
    @current_user = nil # current_userに何もないを代入
  end
  
  def current_user
    # もし一時的セッションの中身が何もなければ、
    if session[:user_id]
      # User.find_byを代入する。それ以外は中身があるから@current_userを返す。
      @current_user = @current_user || User.find_by(id: session[:user_id])
    end
  end
  
  # 現在ログイン中のユーザーがいればtrue、そうでなければfalseを返す
  def logged_in?
    !current_user.nil?
  end
end
