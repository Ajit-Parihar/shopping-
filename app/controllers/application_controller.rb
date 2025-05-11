class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  before_action :set_current_admin_user
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    # Permit extra fields for sign up
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
