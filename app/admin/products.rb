ActiveAdmin.register Product do
  remove_filter :image_attachment, :image_blob

  config.clear_action_items!

  action_item :create_product, only: :index do
    if current_admin_user.seller?
      link_to 'New Product', new_admin_product_path
    end
  end

  scope :all, default: true

  permit_params :name, :price, :brand_name, :discription, :image, :business_id, :rating, :seller_id
  filter :name
  filter :brand_name


  controller do
    def scoped_collection
      if current_admin_user.admin?
 
        Product.with_deleted
  
      elsif current_admin_user.seller?
        Product.joins(:seller_products)
               .where(seller_products: { seller_id: current_admin_user.id })
               .where(deleted_at: nil)
               .distinct
   
      else
        Product.where(deleted_at: nil)
      end
  end
  

  end

  
  form do |f|
    f.inputs "Product Details" do
      f.input :name
      f.input :price
      f.input :brand_name
      f.input :discription
    
      f.input :image, as: :file
      f.input :business_id,
              as: :radio,
              collection: Business.pluck(:category, :id),
              label: "Product Category"
    end
    f.actions
  end

 index do
    selectable_column
     column :image do |product|
      if product.image.attached?
        image_tag url_for(product.image), alt: product.name, style: "max-width: 300px;", class: "product-thumb", onclick: "event.stopPropagation(); highlightImage(this)"
      else
        "No Image"
      end
    end

    column :name
    column :price do |product|
      number_to_currency(product.price, unit: "₹", precision: 0)
    end
    column :brand_name
    column "Rating" do |product|
      product.rating || "Rating Not found"
    end
   

actions defaults: false do |product|
  item "View", resource_path(product), class: "member_link"
  
  if can?(:manage, product) 
    item "Edit", edit_resource_path(product), class: "member_link"
  end

  unless product.deleted_at.present?
    if can?(:destroy, product) 
      item "Delete", resource_path(product),
           method: :delete,
           data: { confirm: "Are you sure?" },
           class: "member_link delete_link"
    end
  end

  if product.deleted_at.present?
    if can?(:update, product) 
      item "Restore", restore_admin_product_path(product),
           method: :put,
           data: { confirm: "Are you sure you want to restore this product?" },
           class: "member_link"
    end
  end
end
end

  show do |res|
    table_for res do 
      column "Image" do |res|
        image_tag(res.image, style: 'max_width: 100px;',  class: "product-thumb", onclick: "highlightImage(this)")
      end
      column :name
      column :price
      column :brand_name
      column :discription
      unless current_admin_user.admin? || current_admin_user.seller?
      column "Buy" do |res|
        span link_to("Buy", admin_buy_path(product_id: res.id), class: "button buy-button")
      end 
      column "Add To card" do 
       span link_to("Add to Cart", admin_addtocard_path(product_id: res), class: "button cart-button")
      end
    end
    end
    
    rating = Rating.where(product_id: product.id)
    unless rating.empty?
      panel "Reviews & Ratings" do
        table_for rating do
          column("Buyer")   { |r| r.admin_user.first_name }
          column("Images") do |r|
            div do
              r.photos.each do |photo|
                span image_tag(url_for(photo), style: "max-width: 100px; margin-right: 10px;")
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

  member_action :buy_product, method: :post do
    if UserAddress.find_by(user_id: current_admin_user.id) && params[:address_id]
      quantity = params[:quantity].to_i
      puts "quantity print"
      
      puts quantity.inspect
      
      address_id = params[:address_id].to_i
      

      order = Order.create_order(current_admin_user, resource, quantity, address_id)

        redirect_to admin_orders_path, notice: "Product bought Successfully"
    else
        redirect_to admin_buy_path(product_id: resource.id), alert: "No Address found"
    end
  end
  member_action :restore, method: :put do
    resource.restore_with_dependents
    redirect_to admin_products_path, notice: "Product and related records restored successfully!"
  end
  
end
