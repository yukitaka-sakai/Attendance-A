class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  #モジュールを読み込みヘルパーで定義したメソッドがどのコントローラーでも使える様になる
  include SessionsHelper
end
