
ActiveAdmin.register Product do

  remove_filter :image_attachment, :image_blob

  permit_params :name, :price, :brand_name, :image, :business_id

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
  
  filter :name
  filter :brand_name
  filter :business, as: :select, collection: -> {
    if current_admin_user.user_type == 'admin'
      Business.all.map { |b| [b.category, b.id] }
    else
      Business.where(seller_id: current_admin_user.id).map { |b| ["Business (#{b.category})", b.id] }
    end
  }, label: "Business Name"
 
  controller do
    def create
      super do |success, failure|
        success.html do
          SellerProduct.create!(
            product_id: resource.id,            
            seller_id: current_admin_user.id
          )
          redirect_to admin_products_path and return
        end
        failure.html { render :new }
      end
    end
      
    def scoped_collection
      if current_admin_user.user_type == "admin"
        Product.all
      else
        seller_product_ids = SellerProduct.where(seller_id: current_admin_user.id).pluck(:product_id)
        Product.where(id: seller_product_ids)
      end
    end
  end

  index  row_class: ->(product) { "clickable-row" } do
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
    item = params[:id]
    unless SellerProduct.find_by(product_id: item.to_i)
        SellerProduct.create(seller_id: current_admin_user.id, product_id: item.to_i)
    end
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
      orders = Order.where(product_id: product.id) 
      sellers = SellerProduct.where(product_id: product.id)
            panel "buyers" do
               table_for orders do
                  column "User" do |order|
               order.user.email
            end
            column "Ordered At" do |order|
              order.created_at.strftime("%B %d, %Y %H:%M")
            end
            column "Seller" do |order|
              order.seller.email
           end
          end 
      end
   end

   member_action :buy_product, method: :post do

    product = Product.find(params[:id])
    
    sellerProduct = SellerProduct.find_by(product_id: product.id)

     sold_count = sellerProduct.sold_count
     if sold_count == nil
      sold_count = 0
    end
    sellerProduct.update(sold_count: sold_count+1)
     sellerProduct.save
    render json: { message: "Product bought successfully!" }
  end

  member_action :add_to_card, method: :post do

    product = Product.find(params[:id])
    
    # sellerProduct = SellerProduct.find_by(product_id: product.id)

    #  sold_count = sellerProduct.sold_count
    #  if sold_count == nil
    #   sold_count = 0
    # end
    # sellerProduct.update(sold_count: sold_count+1)
    #  sellerProduct.save
    render json: { message: "Product bought successfully!" }
  end
  
end
