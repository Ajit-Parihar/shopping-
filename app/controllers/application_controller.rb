class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

   
   helper_method :address

  def current_ability
    @current_ability ||= Ability.new(current_admin_user)
  end



  before_action :set_current_admin_user

  private

  def set_current_admin_user
    Current.admin_user = current_admin_user 
  end

end
