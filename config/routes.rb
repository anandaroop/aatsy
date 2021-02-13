Rails.application.routes.draw do
  resources :subjects do
    collection do
      get 'random'
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
