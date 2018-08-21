Rails.application.routes.draw do

  get 'sessions/new'
  resources :favorites,only: [:create, :destroy]
  root to: 'pictures#index'
  resources :sessions, only: [:new, :create, :destroy]
  resources :users
  resources :pictures do
    collection do
      post :confirm
      get :confirm
      get :list
      get :fav
      get :mypage
    end 
    member do
     get :favshow
     get :myshow
    end
  end
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
