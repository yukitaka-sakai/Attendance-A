class UsersController < ApplicationController
  before_action :set_user,       only: [:show, :edit, :update, :destroy]
  before_action :logged_in_user, only: [:index, :show, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: [:destroy, :edit, :update]
  before_action :set_one_month,  only:  :show
  
  def show # 送られてきたパラメータ（id）と同じidを持つレコードをuserモデルから探し@userに代入
    # @user = User.find(params[:id])
    # @first_day = Date.current.beginning_of_month
    # @last_day = @first_day.end_of_month
    @superiors = User.where(superior: true).select(:name)
    @worked_sum = @attendances.where.not(started_at: nil).count # 
      respond_to do |format|
        format.html 
        format.csv do
            send_data render_to_string, 
            filename: "#{@user.name}-#{@first_day.year}_#{@first_day.month}.csv", type: :csv #csv用の処理を書く
            
        end
      end
  end
  
  def index
    @users = User.paginate(page: params[:page]).search(params[:search])
  end
  
  def import
    if params[:csv_file].blank?
      flash[:danger] = "インポート するCSVファイルを選択してください。"
      redirect_to users_url
    else
      num = User.import(params[:csv_file])  # fileはtmpに自動で一時保存される
      if num > 0
        # debugger
        flash[:success] = "#{num.to_s}件のユーザー情報を追加しました。"
        redirect_to users_url
      else
        flash[:danger] = "読み込みエラーが発生しました。"
        redirect_to users_url
      end
    end
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
    # @user = User.find(params[:id])
  end
  
  def update
    # @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "更新成功"
      redirect_to @user
    else
      render :edit
    end
  end
  
  def destroy
    @user.destroy
    flash[:success] = "#{@user.name}のデータを削除しました。"
    redirect_to users_url
  end
  
  private
  
    def user_params # ストロングパラメーター　ユーザーのパラメーターは
      # requireメソッドでオブジェクト名を定める。permitでキーを指定する。
      params.require(:user).permit(:name, :email, :affiliation, :basic_work_time, :designated_work_start_time, :designated_work_end_time, :password, :password_confirmation)
    end
end
