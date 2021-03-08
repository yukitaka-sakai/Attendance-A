class OfficesController < ApplicationController
  before_action :set_office,       only: [:edit, :destroy, :update]
  before_action :admin_user,     only: [:new, :create, :destroy, :edit, :update, :index]

  
  def new
    @office = Office.new
  end
  
  def index
    @offices = Office.all
  end
  
  def edit
  end
  
  def create
    @office = Office.new(offices_params) #officeモデルの新しいパラメーターを＠officeに代入
    if @office.save#  @officeの登録に成功したら
      if @office.office_type == "出勤"
        @office.office_number = @office.id + 100
        @office.save
      elsif @office.office_type == "退勤"
        @office.office_number = @office.id + 200
        @office.save
      end
      flash[:success] = '拠点登録に成功しました。' # 成功メッセージを出す
      redirect_to offices_url
    else
      render :new # 失敗したらnewに戻る
    end
  end
  
  def edit
  end
  
  def destroy
    @office.destroy
    flash[:success] = "#{@office.office_name}を削除しました。"
    redirect_to offices_url
  end
  
  def update
    if @office.update_attributes(offices_params)
      if @office.office_type == "出勤"
        @office.office_number = @office.id + 100
        @office.save
      elsif @office.office_type == "退勤"
        @office.office_number = @office.id + 200
        @office.save
      end
      flash[:success] = "更新成功"

      redirect_to offices_url
    else
      render :index
    end
  end
  
  private
  
    def offices_params # ストロングパラメーター　officeのパラメーターは
      # requireメソッドでオブジェクト名を定める。permitでキーを指定する。
      params.require(:office).permit(:office_name, :office_number, :office_type)
    end
    
    def mk_number
    end
end
