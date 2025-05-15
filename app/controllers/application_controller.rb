class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  before_action :set_current_admin_user
  before_action :configure_permitted_parameters, if: :devise_controller?

  def after_sign_in_path_for(resource)

    raw = cookies[:cart]
      @cart_data = raw.present? ? JSON.parse(raw, symbolize_names: true) : []
      
      @cart_data.each do |item|
        product_id = item[:id] || item[:product]
        quantity = item[:quantity]
        
        if current_admin_user.seller?
         unless SellerProduct.find_by(seller_id: current_admin_user.id, product_id: product_id)
        cart = AddToCard.find_or_initialize_by(product_id: product_id, admin_user_id: current_admin_user.id)
        cart.quantity = quantity
        cart.save
         end
        end
      end

    cookies.delete(:cart) 
   
    super
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :user_type])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :user_type])
  end

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected
  
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :user_type])
  end
  
  def current_ability
    @current_ability ||= Ability.new(current_admin_user)
  end

  private

  def set_current_admin_user
    Current.admin_user = current_admin_user 
  end

end
