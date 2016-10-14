Rails.application.routes.draw do
  mount ActionCable.server => '/cable'
  resources :sounds
  get '/hook/refresh', to: 'hook#refresh', as: :refresh
  match '/hook/:provider', to: 'hook#create', as: :hook, via: %i(get post)
  get 'board' => 'tester#index'
  get 'default' => 'tester#default'
  root to: 'tester#index'
end
