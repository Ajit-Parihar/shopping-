ActiveAdmin.register Order do
  permit_params :user_id, :product_id, :seller_id, :business_id
  # config.clear_action_items!
  actions :all, except: [:new, :create]
  batch_action :destroy, false

  statuses = %w[ordered packed shipped out_for_delivery delivered cancelled]

  statuses.each do |status|
    batch_action "mark_as_#{status}", if: proc { current_admin_user.seller? } do |selected_ids|
      Order.where(id: selected_ids).update_all(status_type: status)
      redirect_to collection_path, notice: "Selected orders marked as #{status.humanize}."
    end
  end

filter :product
filter :user, as: :select, collection: -> { 
  AdminUser.where(user_type: 'user').map { |user| ["#{user.first_name} #{user.last_name} (#{user.email})", user.id] }
}, label: "Search by User (Name or Email)"
filter :seller, as: :select, collection: -> {
  AdminUser.where(user_type: "seller").map {|seller| ["#{seller.first_name} #{seller.last_name} (#{seller.email})", seller.id]}
}, label: "Search by Seller (Name or Email)"
filter :business, as: :select, collection: -> {
  Business.joins(:products).distinct.pluck(:category, :id)
}, label: "Business"
filter :status_type, as: :select, collection: -> {
  %w[ordered packed shipped out_for_delivery delivered cancelled]
}

  controller do
    # def find_resource
    #   Order.find_by!(product_id: params[:id])
    # end

    def scoped_collection

      if current_admin_user.admin?
        Order.all
      elsif current_admin_user.seller?
        Order.where(seller_id: current_admin_user.id)
      else
        Order.where(user_id: current_admin_user.id)
      end
    end
  end
  
    index do 
       selectable_column 
      
       column "Product" do |order|
        image_tag(order.product.image, style: "max-width: 300px;", class: "product-thumb", onclick: "highlightImage(this)")
      end

      column "User" do |order|
        "#{order.user.first_name} #{order.user.last_name}"
      end

      column :status_type
      column :created_at

      if current_admin_user.user?
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
        # link_to "Check Order", admin_ordertracker_path(order_id: order.id), class: "button"
       link_to "Check Order", admin_order_path(order.id), class: "button"

      end

    end  

    show do

        attributes_table do
          row :id
          row :status_type
          row :created_at
          row :updated_at
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
            column :name
            column :brand_name
    
            column "Rating" do |product|
              product.rating || "Rating Not found"
            end
    
            column "Price" do |p|
              number_to_currency(p.price, unit: "₹")
            end

            column "Seller" do |p|
                 resource.seller.first_name
            end
    
            column "Image" do |p|
              link_to admin_product_path(p.id) do
                image_tag(p.image, style: "max-width: 100px;")
              end
            end
         end
      end
    end

  member_action :cancel_order, method: :post do
      puts resource.inspect
      resource.update(status_type: "cancelled")
      redirect_to admin_order_path(resource.id), notice: "Order Cancel Succssfully"
  end
end
