class HomeController < ApplicationController
  before_action :check
  
  
  def index
     @products = Product.all
  end

  private
  def check 
    puts current_admin_user.inspect
    if current_admin_user
       redirect_to  admin_businesses_path 
    end
  end
end
