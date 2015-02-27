Rails.application.routes.draw do
  resources :games do
    collection do
      get :react
      get :html
    end
  end
end
