class HomeController < ApplicationController
  before_action :check
  
  def index
   @businesses =  Business.joins(:products).distinct
  end

  def product 
     @products = Product.where(business_id: params[:id])
     
  end

  private
  def check 
 
    if current_admin_user
       redirect_to admin_businesses_path 
    end
  end
end
