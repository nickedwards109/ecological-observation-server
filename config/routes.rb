Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get '/observations', to: 'observations#index'
      get '/observations/:id', to: 'observations#show'
      post '/observations', to: 'observations#create'
    end
  end
end
