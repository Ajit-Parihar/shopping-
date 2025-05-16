ActiveAdmin.register AddToCard do
 
  config.batch_actions = false
  config.filters = false

  controller do
    def scoped_collection
      Product.joins(:add_to_cards)
             .where(add_to_cards: { admin_user_id: current_admin_user.id })
             .distinct
    end
  end 

  index do 
    selectable_column

    column "Image" do |product|
      if product.image.attached?
        image_tag(product.image, style: "max-width: 100px;")
      else
        "Image not found"
      end
    end

    column :name
    column :brand_name

    column "Price" do |product|
      number_to_currency(product.price, unit: "₹")
    end

    column "Quantity + Total" do |product|
      cart_item = AddToCard.find_by(admin_user_id: current_admin_user.id, product_id: product.id)
      if cart_item
        render partial: "admin/quantity_total", locals: { cart: cart_item }
      else
        "Not in cart"
      end
    end

    column "Actions" do |product|
      span link_to("Buy", admin_buy_path(product_id: product.id), class: "button buy-button")
    end

    column "Actions" do |product|
      link_to "Remove", remove_admin_add_to_card_path(product),
              method: :patch,
              data: { confirm: "Are you sure?" },
              class: "button buy-button"
    end
  end

  collection_action :add_product, method: :post do
    product = Product.find(params[:product_id])
    AddToCard.create!(admin_user_id: current_admin_user.id, product_id: product.id, quantity: 1)
    redirect_to admin_add_to_cards_path, notice: "Added product to cart."
  end

  member_action :update_quantity, method: :patch do
    puts "udpate quantity"
    cart = AddToCard.find(params[:id])
    cart.update(quantity: params[:quantity])
  end

  member_action :remove, method: :patch do 
    cart = AddToCard.find_by(product_id: params[:id], admin_user_id: current_admin_user.id)
    raw_cookie = cookies[:cart]
    cookie_cart = raw_cookie.present? ? JSON.parse(raw_cookie, symbolize_names: true) : []
    cookie_cart.reject! { |item| item[:id] == cart.product_id }
    cookies[:cart] = cookie_cart.to_json

    if cart
      cart.destroy
      redirect_to admin_add_to_cards_path, notice: "Remove succssfully"
    else
      redirect_to admin_add_to_cards_path, notice: "Not remove some error occurs"
    end
  end
end
