ActiveAdmin.register Order do
  permit_params :user_id, :product_id, :seller_id, :business_id
  batch_action :destroy, false

  filter :product_name_cont, as: :string, label: "Product Name"

  filter :business, as: :select, collection: -> {
    Business.joins(:products).distinct.pluck(:category, :id)
  }, label: "Business"

  filter :status_type, as: :select, collection: -> {
    %w[ordered processing shipped out_for_delivery delivered cancelled]
  }

  controller do
    def scoped_collection
      if current_admin_user.admin?
        Order.all
      else
        Order.where(user_id: current_admin_user.id)
      end
    end

    def show
      @order = Order.find_by(id: params[:id])
    end
  end

  index do
    selectable_column
    column "Product" do |order|
      if order.product.image.attached?
        image_tag(order.product.image, style: "max-width: 300px;", class: "product-thumb", onclick: "highlightImage(this)")
      else
        "image not found"
      end
    end
    column "product Name" do |order|
      order.product.name
    end
    column "User" do |order|
      "#{order.user.first_name} #{order.user.last_name}"
    end
    column :status_type
    column :created_at

    unless current_admin_user.admin?
      column "Rating" do |order|
        rating = Rating.find_by(order_id: order.id)
        if rating.nil? && order.status_type == "delivered"
          link_to "Add Rating", "#", onclick: "productRating(this)", class: "button primary", data: { id: order.id }
        elsif rating.present?
          rating.rate
        else
          "Not Rated Yet"
        end
      end

      column "Cancel Order" do |order|
        unless order.status_type == "delivered" || order.status_type == "cancelled"
          link_to "Cancel", cancel_order_admin_order_path(order),
                  method: :post,
                  data: { confirm: "Are you sure?" },
                  class: "button primary"
        else
          link_to "Cancel", "#", class: "button primary", style: "opacity: 0.5;"
        end
      end
    end

    column "Details" do |order|
      link_to "Check Order", admin_order_path(order.id), class: "button"
    end
  end

  show do
    attributes_table do
      row :id
      row :status_type
      row "purchesed by" do |resource|
        "#{resource.user.first_name} #{resource.user.last_name}"
      end

      row "seller" do |resource|
        "#{resource.seller.first_name} #{resource.seller.last_name}"
      end

      row "Order Placed" do |resource|
        resource.created_at.strftime("%B %d, %Y %I:%M")
      end

      if resource.status_type == "delivered"
        row "Order Deliver" do |resource|
          resource.updated_at.strftime("%B %d, %Y %I:%M")
        end
      else
        row "Order Status" do |resource|
          resource.status_type
        end
      end

      row "Order Deliver Address" do |resource|
        unless resource.user_address == nil
          resource.user_address.full_address
        else
          "Address Not Found"
        end
      end
    end

    panel "Order Progress Overview" do
      percentage = resource.progress_percentage
      color = resource.bar_color

      div style: "margin-bottom: 20px;" do
        div style: "margin-bottom: 10px;" do
          if resource.rating
            link_to "Edit Rating", edit_admin_rating_path(resource.rating), class: "button"
          end
        end

        div style: "display: flex; justify-content:" do
          div style: "display: flex; flex-direction: column; justify-content: space-around; padding-top: 13px" do
            span style: "font-weight: bold; color: #10b981;" do
              "Ordered"
            end

            span style: "font-weight: bold; color: #3b82f6;" do
              "Processing"
            end

            span style: "font-weight: bold; color: #f59e0b;" do
              "Shipped"
            end

            span style: "font-weight: bold; color: #f97316;" do
              "Out for delivery"
            end

            span style: "font-weight: bold; color: #10b981;" do
              "Delivered"
            end

            span style: "font-weight: bold; color: #ef4444;" do
              "Cancelled"
            end
          end

          div style: "height: 275px; width: 20px; background-color: #e5e7eb; border-radius: 5px; overflow: hidden; margin-top: 10px;" do
            div style: "width: 100%; height: #{percentage}%; background-color: #{color}; transition: height 1s ease;" do
            end
          end

          h4 style: "padding-left: 20px; color: #{color}; padding-right: 20px" do
            "Order #{resource.status_type}"
          end
        end
      end
    end

    panel "Deliver Product Details" do
      table_for resource.product do
        column "Image" do |p|
          link_to admin_product_path(p.id) do
            if p.image.attached?
              image_tag(p.image, style: "max-width: 100px;")
            else
              "image not found"
            end
          end
        end

        column :name
        column :brand_name

        column "Rating" do |product|
          product.rating || "Rating Not found"
        end

        column "Price" do |p|
          number_to_currency(p.price, unit: "₹")
        end

        column "Qunatity" do
          resource.quantity
        end

 
      end
    end
  end

  member_action :cancel_order, method: :post do
    puts "working order"
    order = Order.find(params[:id])
    order.update(status_type: "cancelled")
    redirect_to admin_orders_path, notice: "Order Cancel Succssfully"
  end
end
