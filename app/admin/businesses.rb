ActiveAdmin.register Business do
  permit_params :category, :seller_id, :create_at, :updated_at

  menu label: proc {
    if current_admin_user.seller?
      "My Business"
    elsif current_admin_user.admin?
      "All Business"
    else
      "Home"
    end
  }

  scope :all, default: true
  scope("With User") { |businesses| businesses.where.not(seller_id: nil) }

  form do |f|
    f.inputs "Business Details" do
      f.input :category,
              as: :radio,
              collection: Rails.application.config.images_hash.keys,
              label: "Product Category"

      f.input :seller_id,
              input_html: { value: current_admin_user.id, readonly: true }
    end
    f.actions
  end

  controller do
    def scoped_collection
      if current_admin_user.admin? || current_admin_user.user?
        Business.all
      else
        Business.where(seller_id: current_admin_user)
      end
    end
  end

  filter :category
  filter :seller_id,
         as: :select,
         collection: -> {
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
    unless current_admin_user.user?
    column "Orders" do |business|
        link_to "View Orders", admin_orders_path(business_id: business.id)
    end
  end

    column "" do |business|
      content_tag(:span, "", class: "row-link", data: { href: admin_business_path(business) })
    end

    actions
  end

  show  do
    panel "Products", class: "fade-in-section" do
      products = Product
                   .where(business_id: business.id)
                   .select("name, MAX(id) AS id, MAX(price) AS price, MAX(brand_name) AS brand_name")
                   .group(:name)
    
      table_for products, class: "clickable-table" do
        column :id
        column :name
        column :price
        column :brand_name
    
        column :image do |product|
          if product.image.attached?
            image_tag url_for(product.image), alt: product.name, style: 'max-width: 300px;', class: "product-thumb", onclick: "event.stopPropagation(); highlightImage(this)"
          else
            "No image"
          end
        end
      end
    end
  end
end
