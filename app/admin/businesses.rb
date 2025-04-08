
ActiveAdmin.register Business do

    permit_params :category, :seller_id, :create_at, :updated_at

    scope :all, default: true
    scope("With User") { |businesses| businesses.where.not(seller_id: nil) }

    form do |f|
      f.inputs "Business Details" do
        f.input :category, as: :radio, collection: Rails.application.config.images_hash.keys, label: "Product Category"  
        f.input :seller_id, input_html: { value: current_admin_user.id, readonly: true }
      end
      f.actions
    end

    controller do
      def scoped_collection
        if current_admin_user.user_type == "admin" || current_admin_user.user_type == "user"
          Business.all
        else
          Business.where(seller_id: current_admin_user) 
        end
      end
    end

    filter :category
    filter :seller_id, as: :select, collection: -> {
  AdminUser.where(user_type: 'seller').map { |u| [u.email, u.id] }
}

    index row_class: -> (business) { "clickable-row" } do 
      selectable_column
      id_column
      column :seller
      column :category
      column :created_at
      column :image do |business|
        category = business.category
        image_url = Rails.application.config.images_hash[category.to_sym] if Rails.application.config.images_hash.key?(category.to_sym)
          if image_url
          image_tag(image_url, alt: "#{category} Image", style: "max-width: 300px;", class: "product-thumb", onclick: "highlightImage(this)")
          else
          "No image available"
          end
      end
      column "Orders" do |business|
        link_to "View Orders", admin_orders_path(business_id: business.id)     
       end

       column "" do |business|
          content_tag(:span, "", class: "row-link", data: {href: admin_business_path(business)} )
       end
      actions
    end

show do |res|
user_seller = AdminUser.find(business.seller_id)
seller = "#{user_seller.first_name} #{user_seller.last_name}"

div class: "business-header" do
  attributes_table_for business do
    row :seller do
      seller
    end
    row :category 
    row :image do |b|
      category = b.category
      image_url = Rails.application.config.images_hash[category.to_sym] if Rails.application.config.images_hash.key?(category.to_sym)
      if image_url
        image_tag image_url, alt: "#{category} Image", class: "header-image"
      else
        "No image available"
      end
    end
  end
end

panel "Products", class: "fade-in-section" do
  products = Product
              .where(business_id: business.id)
              .select("name, MAX(id) AS id, MAX(price) AS price, MAX(brand_name) AS brand_name")
              .group(:name)

  table_for products do
    column :name
    column :price 
    column :brand_name
    column :image do |product|
      if product.image.attached?
        image_tag url_for(product.image), alt: product.name, style: 'max-width: 300px;',  class: "product-thumb"
      else
        "No image"
      end
    end
    column "Actions" do |product|
      span link_to "Buy", "#", class: "button buy-button", data: {product_id: product.id}, onclick: "buyProduct(this)"
        span " "
      span link_to "Add to Cart", "#", class: "button cart-button", data: {product_id: product.id}, onclick: "addToCard(this)"
    end
   end
  end
 end
end


