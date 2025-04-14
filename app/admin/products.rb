ActiveAdmin.register Product do
  config.batch_actions = false
  remove_filter :image_attachment, :image_blob

  permit_params :name, :price, :brand_name, :discription, :image, :business_id, :rating, :seller_id


  filter :name
  filter :brand_name


  controller do
    def scoped_collection
      if current_admin_user.admin? 
         Product.all
      elsif current_admin_user.seller?  
        Product.all         #changes are needed
      else
        Product.all
      end
    end

    def create
      super do |format|
        product = resource
        SellerProduct.create(
          seller_id: current_admin_user.id,
          product_id: product.id,
          business_id: product.business_id
        )
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

  index row_class: ->(product) { "clickable-row" } do
    selectable_column
    id_column

    column :name do |product|
      truncate(product.name, length: 30)
    end

    column :price do |product|
      number_to_currency(product.price, unit: "₹", precision: 0)
    end

    column "Image" do |product|
      if product.image.attached?
        image_tag url_for(product.image), alt: product.name, class: "product-thumb", onclick: "highlightImage(this)"
      else
        status_tag "No Image", :warning
      end
    end

    column "" do |product|
      content_tag(:span, "", class: "row-link", data: { href: admin_product_path(product) })
    end
  end

  show do
    attributes_table do
      row :image do |product|
        if product.image.attached?
          image_tag product.image, alt: product.name, style: 'max-width: 300px;'
        else
          "No image available"
        end
      end
      row :price
      row :name
      row :brand_name
      row :discription
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
    if UserAddress.exists?(user_id: current_admin_user.id)
      quantity = params[:quantity].to_i
      product = Product.find(params[:id])
      seller_product = SellerProduct.find_by(product_id: product.id)

      if seller_product
        order = Order.create(
          user_id: current_admin_user.id,
          product_id: product.id,
          seller_id: seller_product.seller_id,
          business_id: product.business_id
        )

        # Update sold count
        current_sold_count = seller_product.sold_count || 0
        seller_product.update(sold_count: current_sold_count + quantity)

        render json: { message: "Product bought successfully!", sold_count: seller_product.sold_count }
      else
        render json: { error: "SellerProduct not found for this product." }, status: :not_found
      end
    else
      render json: { error: "No address found for the user." }, status: :unprocessable_entity
    end
  end
end
