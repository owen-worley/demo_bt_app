Rails.application.routes.draw do

  get 'welcome/index'

  resources :checkouts

  root 'welcome#index'

end
