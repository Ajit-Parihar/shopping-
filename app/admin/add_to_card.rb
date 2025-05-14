ActiveAdmin.register_page "AddToCard" do

$cart_data 
  controller do
    def index
      raw = cookies[:cart]
      $cart_data = raw.present? ? JSON.parse(raw, symbolize_names: true) : []
    
    end
  end

  content title: "Add To Cart" do

    products = Product.joins(:add_to_cards)
                      .where(add_to_cards: { admin_user_id: current_admin_user.id })
                      .distinct
       
                    #   if $cart_data.present?
                    #     puts "not present"
                    #   $cart_data.each do |item|
                    #   end
                    # end

                    # if $cart_data.present?
                    #   puts $cart_data.inspect
                    #   panel "Cart Items" do
                    #     table_for $cart_data do |item|
                    #       puts "print"
                    #       puts "#{item[:id]}"
                    #       product = Product.find { item[:id] }
                    #       puts "working product"
                    #       puts product.inspect
                    #       column("Product Name") { product.name }
                    #       column("Product ID")   { product.id }
                    #       column("Quantity")     { item[:quantity] }
                    #     end
                    #   end
                    # end

    unless products.empty?
      panel "Product Detail" do
        table_for products do
          column "Image" do |product|
            image_tag(product.image, style: "max-width: 100px;")
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
        end
      end
    else
      para "Your cart is empty."
    end
  end
end
