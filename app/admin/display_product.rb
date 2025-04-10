# frozen_string_literal: true
ActiveAdmin.register_page "DisplayProduct" do
  menu false
  content do
    product = Product.find(params[:product_id])
      panel "product" do
         table_for product do

            column "Image" do |product|
              image_tag(product.image, style: "max-width: 100px;")
            end
            column :name

            column :brand_name

            column "Price" do |product|
              number_to_currency(product.price, unit: "₹")
            end

            column :discription

            if current_admin_user.user?
              column "Actions" do |product|
                span link_to "Buy", admin_buy_path(product_id: product), class: "button buy-button", onclick: "event.stopPropagation()" 
                span " "
                span link_to "Add to Cart", admin_addtocard_path(product_id: product), class: "button cart-button", onclick: "event.stopPropagation()"
              end
            end
         end
      end
  end
end
