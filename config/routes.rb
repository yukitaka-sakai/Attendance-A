Rails.application.routes.draw do
  
# トップページ
  root 'static_pages#top'
  get  '/signup', to:'users#new'
  
# ログインのルーティング
  get     '/login', to: 'sessions#new'
  post    '/login', to: 'sessions#create'
  delete  '/login', to: 'sessions#destroy'

# 拠点のルーティング
  resources :offices

# ユーザーに紐づける
  resources :users do
    member do
      # ユーザー基本情報
      get   'edit_basic_info'
      patch 'update_basic_info'
      
      # 勤怠情報編集
      get   'attendances/edit_one_month'
      patch 'attendances/update_one_month'
      get   'approval_show'
    end

    # 勤怠情報編集確認
    get   'approval_edit_month'
    patch 'update_approval_edit_month'

    # 残業申請確認
    get   'approval_overtime_request'
    patch 'update_approval_overtime_request'
    
    # 1ヶ月の申請確認
    get   'approval_one_month'
    patch 'update_approval_one_month'
    
    # 勤怠情報に紐付ける
    resources :attendances, only: [:update, :edit] do
      member do
        # 残業申請依頼
        get   'overtime_request'
        patch 'update_overtime_request'
      end
    end
    
    resources :reports, only: :update
    
    # ユーザー情報をCSVからインポート
    collection { post :import }
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
