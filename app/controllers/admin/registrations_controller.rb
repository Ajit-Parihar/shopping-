module Admin
  class RegistrationsController < Devise::RegistrationsController
    layout 'application' # Use ActiveAdmin layout

    private

    def sign_up_params
      params.require(:admin_user).permit(:email, :password, :password_confirmation, :first_name, :last_name, :user_type)
    end

    def account_update_params
      params.require(:admin_user).permit(:email, :password, :password_confirmation, :current_password, :first_name, :last_name, :user_type)
    end
  end
end