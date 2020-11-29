Rails.application.routes.draw do
  match 'auth/:provider/callback', to: 'facebook/users#create', via: [:get]
  resources :users, only: [:show, :edit, :update] do # 會員中心頁面, 編輯頁面, 會員資料更新
    collection do
      get "/profile", to: "users#show" # 會員中心頁面(取代 users/:id)
    end
  end
  resources :subscriptions, only: [:index, :create] # 訂閱介紹頁面, 建立訂閱單
  resources :sessions, only: [:create] # 進行登入
  get "sign_in", to: "sessions#new" # 登入頁面
  delete "sign_out", to: "sessions#destroy" # 登出
  resources :registrations, only: [:new, :create] # 註冊頁面, 進行註冊
  namespace :registrations do
    resources :confirmations, only: [:new, :show] # 註冊確認信已寄出頁面, 信箱確認成功頁面
  end
  resources :passwords, only: [:show, :edit, :update] # 重置密碼成功頁面, 改密碼的頁面, 密碼更新
  namespace :passwords do
    resources :resets, only: [:new, :show, :create] # 申請設定新密碼信件頁面, 設定新密碼信件已寄出頁面, 寄出設定新密碼信件
  end
end