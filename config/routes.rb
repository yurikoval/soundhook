Rails.application.routes.draw do
  resources :sounds
  match '/hook/:provider', to: 'hook#create', as: :hook, via: %i(get post)
  get 'tester/index'
  root to: 'tester#index'
end
