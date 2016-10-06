Rails.application.routes.draw do
  mount ActionCable.server => '/cable'
  resources :sounds
  post '/hook/youtube', to: "hook#youtube"
  match '/hook/:provider', to: 'hook#create', as: :hook, via: %i(get post)
  get 'tester/index'
  root to: 'sounds#index'
end
