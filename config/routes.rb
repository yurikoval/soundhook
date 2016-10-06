Rails.application.routes.draw do
  mount ActionCable.server => '/cable'
  resources :sounds
  match '/hook/:provider', to: 'hook#create', as: :hook, via: %i(get post)
  get 'tester/index'
  root to: 'sounds#index'
end
