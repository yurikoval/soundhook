Rails.application.routes.draw do
  match '/hook/:provider', to: 'hook#create', as: :hook, via: %i(get post)
end
