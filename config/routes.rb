Faceorama::Application.routes.draw do
  root :to => "images#new"

  resources :images

  match "login" => "home#login", :as => "login"

end
