class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  before_action :set_current_admin_user

  def current_ability
    @current_ability ||= Ability.new(current_admin_user)
  end

  private

  def set_current_admin_user
    Current.admin_user = current_admin_user 
  end

end
