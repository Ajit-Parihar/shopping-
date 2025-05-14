class HomeController < ApplicationController
  before_action :check
  
  def index
   @businesses =  Business.joins(:products).distinct
  end

  def product 
     @products = Product.where(business_id: params[:id])
     
  end

  def addToCart
    @product = Product.find(params[:id])
  
    cart = cookies[:cart] ? JSON.parse(cookies[:cart]) : []
  
    existing_item = cart.find { |item| item["id"] == @product.id }
  
    if existing_item
      existing_item["quantity"] = existing_item["quantity"].to_i + 1
    else
      cart << { "id" => @product.id, "quantity" => 1 }
    end
  
    cookies[:cart] = { value: cart.to_json, expires: 1.month.from_now }
  
    redirect_to cart_path
  end
  
  def cart
    @cart = cookies[:cart] ? JSON.parse(cookies[:cart]) : []
    @products_in_cart = @cart.map do |item|
      product = Product.find(item["id"])  
      { product: product, quantity: item["quantity"] }
    end
  end

  def update_cart_quantity

    product_id = params[:id].to_i
    new_quantity = params[:quantity].to_i

    puts "product #{product_id.inspect}"
    puts "quantity #{new_quantity.inspect}"
  
    cart = cookies[:cart] ? JSON.parse(cookies[:cart]) : []
  
    cart.each do |item|
      if item["id"] == product_id
        item["quantity"] = new_quantity
      end
    end
  
    cookies[:cart] = { value: cart.to_json, expires: 1.month.from_now }
  
    head :ok
  end

  def addtocart_remove
    raw = cookies[:cart]
    cart = raw.present? ? JSON.parse(raw, symbolize_names: true) : []
  
    cart.reject! { |item| item[:product] == params[:id].to_i }

    cookies[:cart] = {
      value: JSON.generate(cart),
      expires: 1.week.from_now
    }

     redirect_to cart_path
  end
  
  private

  def check 
 
    if current_admin_user
       redirect_to admin_businesses_path 
    end
  end
end
