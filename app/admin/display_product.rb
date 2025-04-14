# frozen_string_literal: true

ActiveAdmin.register_page "DisplayProduct" do
  menu false

  content do
    product = Product.find(params[:product_id])
    rating = Rating.where(product_id: product.id)

    panel "Product" do
      table_for product do
        column "Image" do |p|
          image_tag(p.image, style: "max-width: 100px;")
        end

        column :name
        column :brand_name

        column "Price" do |p|
          number_to_currency(p.price, unit: "₹")
        end

        column :discription

        if current_admin_user.user?
          column "Actions" do |p|
            span link_to("Buy", admin_buy_path(product_id: p), class: "button buy-button", onclick: "event.stopPropagation()")
            span " "
            span link_to("Add to Cart", admin_addtocard_path(product_id: p), class: "button cart-button", onclick: "event.stopPropagation()")
          end
        end
      end
    end

    unless rating.empty?
      panel "Reviews & Ratings" do
        table_for rating do
          column "Buyer" do |r|
            r.admin_user.first_name
          end

          column "Images" do |r|
            div do
              r.photos.each do |photo|
                span image_tag(url_for(photo), style: "max-width: 100px; margin-right: 10px;", onclick: "highlightImage(this)")
              end
            end
          end

          column :rate
          column :comments
          column :created_at
        end
      end
    end
  end
end
