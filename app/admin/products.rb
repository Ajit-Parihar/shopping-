ActiveAdmin.register Product do
  remove_filter :image_attachment, :image_blob

  config.clear_action_items!
  config.batch_actions = false

  action_item :edit, only: :show, if: proc { current_admin_user.admin? } do
    link_to "Edit Product", edit_resource_path(resource)
  end

  action_item :destroy, only: :show, if: proc { current_admin_user.admin? } do
    link_to "Delete Product", resource_path(resource),
            method: :delete,
            data: { confirm: "Are you sure?" }
  end

  scope :all, default: true do |products|
    if current_admin_user.seller?
      seller_product_ids = SellerProduct.where(seller_id: current_admin_user.id).pluck(:product_id)
      products.where.not(id: seller_product_ids)
    elsif current_admin_user.admin?
      products.with_deleted
    else
      products.where(deleted_at: nil)
    end
  end

  permit_params :name, :price, :brand_name, :discription, :image, :business_id, :rating, :seller_id

  filter :name
  filter :brand_name

  controller do
    def scoped_collection
      if current_admin_user.admin?
        Product.with_deleted
      elsif current_admin_user.seller?
        Product.where(deleted_at: nil)
      else
        Product.where(deleted_at: nil)
      end
    end

    def show
      @product = Product.find_by(id: params[:id])
      if @product.nil?
        redirect_to admin_products_path, alert: "Product not found."
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
      item "View", resource_path(product), class: "button buy-button"

      if product.deleted_at.present?
        if can?(:update, product)
          item "Restore", restore_admin_product_path(product),
               method: :put,
               data: { confirm: "Are you sure you want to restore this product?" },
               class: "button buy-button"
        end
      end

      if current_admin_user.admin?
        item "Edit", edit_resource_path(product), class: "button buy-button"

        if product.deleted_at == nil
          link_to "Delete", resource_path(product),
                  method: :delete,
                  data: { confirm: "Are you sure?" },
                  class: "button buy-button"
        end
      end
    end
  end

  show do |res|
    table_for res do
      column "Image" do |res|
        if res.image.attached?
          image_tag(res.image, style: 'max_width: 100px;', class: "product-thumb", onclick: "highlightImage(this)")
        else
          "Image not found"
        end
      end
      column :name
      column :price
      column :brand_name
      column :discription

      unless current_admin_user.admin?
        column "Buy" do |res|
          span link_to("Buy", admin_buy_path(product_id: res.id), class: "button buy-button")
        end

        column "Add To Cart" do |res|
          span link_to("Add to Cart", add_product_admin_add_to_cards_path(product_id: res.id), method: :post, class: "button cart-button")
        end
      end
    end

    rating = Rating.where(product_id: product.id)
    unless rating.empty?
      panel "Reviews & Ratings" do
        table_for rating do
          column("Buyer") { |r| r.admin_user.first_name }
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
      address_id = params[:address_id].to_i
      order = Order.create_order(current_admin_user, resource, quantity, address_id)
      redirect_to admin_orders_path, notice: "Product bought Successfully"
    else
      redirect_to admin_buy_path(product_id: resource.id), alert: "No Address found"
    end
  end

    
    member_action :restore, method: :put do
  product = Product.with_deleted.find(params[:id])
  product.restore
     product.restore_with_dependents
    redirect_to admin_products_path, notice: "Product and related records restored successfully!"
  end
end
