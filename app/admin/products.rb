ActiveAdmin.register Product do

  remove_filter :image_attachment, :image_blob

  permit_params :name, :price, :brand_name,  :image, :business_id, :rating, :seller_id

  controller do
    def scoped_collection
      if current_admin_user.admin?
        Product.all
      elsif current_admin_user.seller?
        # products = Product.where(id: SellerProduct.where(seller_id: current_admin_user.id).pluck(:product_id))
        Product.all
      else
        Product.all
      end
    end
  end

  form do |f|
    f.inputs "Product Details" do
      f.input :name
      f.input :price
      f.input :brand_name
      f.input :image, as: :file
      f.input :business_id, as: :radio, collection: Business.pluck(:category, :id), label: "Product Category"
    end
    f.actions
  end

  controller do
    def create
      super do |format|
        product = resource
         SellerProduct.create(seller_id: current_admin_user.id, product_id: product.id, business_id: product.business_id)
        end
      end
  end

  filter :name
  filter :brand_name
  # filter :business, as: :select, collection: -> {
  #   if current_admin_user.admin?
  #     Business.all.map { |b| [b.category, b.id] }
  #   else
  #     Business.where(seller_id: current_admin_user.id).map { |b| ["Business (#{b.category})", b.id] }
  #   end
  # }, label: "Business Name"

  

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
    item = params[:id].to_i

    # unless SellerProduct.find_by(product_id: item)
    #   SellerProduct.create(seller_id: current_admin_user.id, product_id: item)
    # end

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
    end

    rating = Rating.where(product_id: product.id)

    panel "Reviews&Ratings" do 
      table_for rating do
       column "Buyer" do |rating|
          rating.admin_user.first_name
       end
       column "Images" do |rating|
         div do
           rating.photos.each do |photo|
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

  member_action :buy_product, method: :post do

    if UserAddress.find_by(user_id: current_admin_user.id)

    quantity = params[:quantity].to_i

    product = Product.find(params[:id])
    seller_product = SellerProduct.find_by(product_id: product.id)
    order = Order.create(user_id: current_admin_user.id, product_id: product.id, seller_id: seller_product.seller_id, business_id: product.business_id, deliver: false, cancel: false, pending: true)
    order.save
    if seller_product
      current_sold_count = seller_product.sold_count || 0
      seller_product.update(sold_count: current_sold_count + quantity)

      render json: { message: "Product bought successfully!", sold_count: seller_product.sold_count }
    else
      render json: { error: "SellerProduct not found for this product." }, status: :not_found
    end
  end
 end
end