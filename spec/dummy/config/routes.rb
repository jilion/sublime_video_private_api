Dummy::Application.routes.draw do
  namespace :private_api do
    resources :foos, defaults: { format: :json }
  end
end
