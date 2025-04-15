ActiveAdmin.register_page "AddToCard" do
  
  content title: "Add To Card" do
    if params[:product_id]
    product = Product.find(params[:product_id])
    
      AddToCard.find_or_create_by(admin_user_id: current_admin_user.id, product_id: product.id) do |cart|
          cart.admin_user_id = current_admin_user.id
          cart.quantity = 1
          cart.product_id = product.id
      end
  end

  products = Product.joins(:add_to_cards).where(add_to_cards: { admin_user_id: current_admin_user.id }).distinct
    panel "Product Detail" do
      table_for products do
        column :name

        column :brand_name

        column "Price" do |product|
          number_to_currency(product.price, unit: "₹")
        end

        column "Image" do |product|
          image_tag(product.image, style: "max-width: 100px;")

        end

        column "Quantity + Total" do |product|
          render partial: "admin/quantity_total", locals: { product: product }
        end
        column "Actions" do |product|

          span link_to("Buy", admin_buy_path(product_id: product.id), class: "button buy-button", onclick: "event.stopPropagation()")
        end
      end
    end
  end
end
