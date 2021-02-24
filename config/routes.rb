Rails.application.routes.draw do
  root to: "subjects#index"

  resources :subjects do
    collection do
      get 'random'
      get 'random_material'
      get 'search'
      get 'search_materials'
      get 'complete'
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
