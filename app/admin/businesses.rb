
ActiveAdmin.register Business do

    permit_params :category, :seller_id, :create_at, :updated_at

    form do |f|
      f.inputs "Business Details" do
        f.input :category, as: :radio, collection: Rails.application.config.images_hash.keys, label: "Product Category"  
        f.input :seller_id, input_html: { value: current_admin_user.id, readonly: true }
      end
      f.actions
    end

    scope :all, default: true
    scope("With User") { |businesses| businesses.where.not(seller_id: nil) }

    controller do
      def scoped_collection
        if current_admin_user.user_type == "admin"

          puts current_admin_user.inspect
            puts "all okey"

          Business.all
        else
          Business.where(seller_id: current_admin_user) 
        end
      end
    end

    index do
      selectable_column
      id_column
      column :seller
      column :category
      column :created_at
      column :image do |business|
        category = business.category
        image_url = Rails.application.config.images_hash[category.to_sym] if Rails.application.config.images_hash.key?(category.to_sym)
          if image_url
           link_to image_tag(image_url, alt: "#{category} Image", style: "max-width: 300px;"), admin_business_path(business)
          else
          "No image available"
          end
      end
      column "Orders" do |business|
        link_to "View Orders", admin_orders_path(business_id: business.id)     
       end
      actions
    end

      show do
       products = Product
      .where(business_id: business.id)
      .select("name, MAX(id) AS id, MAX(price) AS price, MAX(brand_name) AS brand_name")
      .group(:name)

      user_seller = AdminUser.find(business.seller_id)
      seller = user_seller.email
      attributes_table do
        row :seller do
          seller
       end
         row :category
         row :image do |business|
          category = business.category
          image_url = Rails.application.config.images_hash[category.to_sym] if Rails.application.config.images_hash.key?(category.to_sym)
          if image_url
           link_to image_tag(image_url, alt: "#{category} Image", style: "max-width: 300px;"), admin_business_path(business)
          else
          "No image available"
          end
      end
      end

       panel "products" do 
       table_for products do
            column :name
            column :price
            column :brand_name
            column :image do |product|
              image_tag product.image, alt: product.name, style: 'max-width: 300px;' 
            end
       end
       end
    end
end


