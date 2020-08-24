class OfficesController < ApplicationController
  
  def new
    @office = Office.new
  end
  
  def index
    @offices = Office.all
  end
  
  def create
    @office = Office.new(offices_params) #officeモデルの新しいパラメーターを＠officeに代入
    # debugger
    if @office.save #  @officeの登録に成功したら
      flash[:success] = '拠点登録に成功しました。' # 成功メッセージを出す
      redirect_to offices_url
    else
      render :new # 失敗したらnewに戻る
    end
  end
  
  private
  
    def offices_params # ストロングパラメーター　officeのパラメーターは
      # requireメソッドでオブジェクト名を定める。permitでキーを指定する。
      params.require(:office).permit(:office_name, :office_number)
    end
    
    def mk_number
    end
end
