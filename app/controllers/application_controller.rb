class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  #モジュールを読み込みヘルパーで定義したメソッドがどのコントローラーでも使える様になる
  include SessionsHelper
  
  $days_of_the_week = %w{日 月 火 水 木 金 土}

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
    redirect_to root_url unless current_user?(@user) || current_user.admin?#current_userがuserと違うならトップページに戻る
  end
  
  def admin_user
    redirect_to root_url unless current_user.admin?
  end
    
  def set_one_month
    # paramsにdateが存在するか？なければ,現在の月の始まりを、そうでなければパラメーターの日
    @first_day = params[:date].nil? ?
    Date.current.beginning_of_month : params[:date].to_date
    @last_day = @first_day.end_of_month
    one_month = [*@first_day..@last_day] # 対象の月の日数を代入
    # ユーザーに紐づく一ヶ月分の勤怠データを検索取得
    @attendances = @user.attendances.where(worked_on: @first_day..@last_day).order(:worked_on)
    unless one_month.count == @attendances.count # それぞれの件数が一致するか
      ActiveRecord::Base.transaction do  # トランザクションを開始する
        # 繰り返し処理により、1ヶ月分の勤怠データを生成する
        one_month.each { |day| @user.attendances.create!(worked_on: day) }
      end
      @attendances = @user.attendances.where(worked_on: @first_day..@last_day).order(:worked_on)
    end
  
  
  rescue ActiveRecord::RecordInvalid #トランザクションによるエラー分岐
    flash[:danger] = "失敗"
    redirect_to root_url
  end

  def set_month
    # paramsにdateが存在するか？なければ,現在の月の始まりを、そうでなければパラメーターの日
    @first_day = params[:date].nil? ?
    Date.current.beginning_of_month : params[:date].to_date
    @last_day = @first_day.end_of_month
    one_month = [*@first_day..@last_day] # 対象の月の日数を代入
    # ユーザーに紐づく一ヶ月分の勤怠データを検索取得
    @attendances = @user.attendances.where(worked_on: @first_day..@last_day).order(:worked_on)

    unless one_month.count == @attendances.count # それぞれの件数が一致するか
      ActiveRecord::Base.transaction do  # トランザクションを開始する
        # 繰り返し処理により、1ヶ月分の勤怠データを生成する
        one_month.each { |day| @user.attendances.create!(worked_on: day) }
      end
      @attendances = @user.attendances.where(worked_on: @first_day..@last_day).order(:worked_on)
    end
  
  
  rescue ActiveRecord::RecordInvalid #トランザクションによるエラー分岐
    flash[:danger] = "失敗"
    redirect_to root_url
  end
end