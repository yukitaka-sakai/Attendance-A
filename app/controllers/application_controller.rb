class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  #モジュールを読み込みヘルパーで定義したメソッドがどのコントローラーでも使える様になる
  include SessionsHelper
  
  $day_of_the_week = %w{日 月 火 水 木 金 土}
end
