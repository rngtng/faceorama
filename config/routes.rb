Faceorama::Application.routes.draw do
  root :to => "images#new"

  resources :images
end
