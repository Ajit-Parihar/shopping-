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

    # def create
    #  super do |create|
    #     product = resource
    #     SellerProduct.create(
    #       seller_id: current_admin_user.id,
    #       product_id: product.id,
    #       business_id: product.business_id
    #     )
    #  end
    # end
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

    # column :name do |product|
    #   truncate(product.name, length: 30)
    # end
    # 
    column :name
     
   column :price do |product|
      number_to_currency(product.price, unit: "₹", precision: 0)
    end

    column :brand_name

    column "Rating" do |product|
       product.rating || "Rating Not found"
    end

    column :image do |product|
      if product.image.attached?
        image_tag url_for(product.image), alt: product.name, style: "max-width: 300px;", class: "product-thumb", onclick: "event.stopPropagation(); highlightImage(this)"
      else
         "No Image"
      end
    end
    column "" do |product|
      content_tag(:span, "", class: "row-link", data: { href: admin_product_path(product) })
    end
  end

  show do |res|
    puts "working fine"
    puts res.inspect
    table_for res do 
      column "Image" do |res|
        image_tag(res.image, style: 'max_width: 100px;',  class: "product-thumb", onclick: "highlightImage(this)")
      end
      column :name
      column :price
      column :brand_name
      column :description
      column "Buy" do |res|
        span link_to("Buy", admin_buy_path(product_id: res.id), class: "button buy-button", onclick: "event.stopPropagation()")
      end 
      column "Add To card" do 
       span link_to("Add to Cart", admin_addtocard_path(product_id: res), class: "button cart-button", onclick: "event.stopPropagation()")
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
    product = Product.find(params[:id])

    if UserAddress.find_by(user_id: current_admin_user.id)
      quantity = params[:quantity].to_i
  
      order = Order.create_order(current_admin_user, product, quantity)

      redirect_to admin_order_path(order), notice: "Product bought Successfully"
    else
        redirect_to admin_buy_path(product_id: product.id), alert: "No Address found"
    end
  end
  
end
