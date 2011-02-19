Faceorama::Application.routes.draw do
  root :to => "images#new"

  resource :images
end
