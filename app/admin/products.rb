
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
    def scoped_collection
      if current_admin_user.user_type == "admin"
        Product.all
      else
        seller_product_ids = SellerProduct.where(seller_id: current_admin_user.id).pluck(:product_id)
        Product.where(id: seller_product_ids)
      end
    end
  end

  index do
     selectable_column
      id_column
      column :name
      column :brand_name
      column :price
      column :image do |product|
        if product.image.attached?
          link_to image_tag(product.image, alt: product.name, style: 'max-width: 300px;'), admin_product_path(product)
        else
          "No image available"
        end
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
      puts "working fine"
      puts orders.inspect
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
end
