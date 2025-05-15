Rails.application.routes.draw do
  get "partial/quantity_total"
  get "pages/quantity_total"
  get "pages/index"
  get "home/index"
#   devise_for :admin_users, ActiveAdmin::Devise.config
devise_for :admin_users, ActiveAdmin::Devise.config.merge(
  controllers: {
    registrations: 'admin/registrations',
    # passwords: 'admin/passwords'
  }
)
  ActiveAdmin.routes(self)

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
   root "home#index"
   get "product/:id", to: "home#product", as: "product"
   patch 'add_to_cards/:product_id/update_quantity', to: 'add_to_cards#update_quantity', as: 'update_cart_quantity'
   post "AddToCart/:id", to: "home#addToCart", as: "addToCart"
   get "cart", to: "home#cart", as: "cart"
   post "/update_cart_quantity", to: "home#update_cart_quantity", as: "update_quantity"
   post "/addtocart/remove/:id", to: "home#addtocart_remove", as: "addtocart_remove"
   get "/product/show/:id", to: "home#product_show", as: "product_show"
  # get "page/not_found", to: "errors#not_found"
  # get "page/unauthorized", to: "errors#unauthorized"
end
