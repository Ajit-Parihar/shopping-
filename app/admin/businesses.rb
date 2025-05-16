ActiveAdmin.register Business do

  config.batch_actions = false
  config.filters = false

  menu label: proc {
    if current_admin_user.admin?
      "All Business"
    else
      "Home"
    end
  }

  scope :all, default: true

  controller do
    def scoped_collection
      if current_admin_user.admin? || current_admin_user.user?
        Business.joins(:products).distinct
      else
        Business.joins(:products)
                .joins("INNER JOIN seller_products ON seller_products.business_id = businesses.id")
                .where(products: { deleted_at: nil })
                .where.not(seller_products: { seller_id: current_admin_user.id })
                .distinct
      end
    end
  end

  index row_class: ->(business) { "clickable-row" } do
    selectable_column
    id_column

    column :image do |business|
      category = business.category
      image_url = Rails.application.config.images_hash[category.to_sym] if Rails.application.config.images_hash.key?(category.to_sym)

      if image_url
        image_tag(image_url, alt: "#{category} Image", style: "max-width: 300px;", class: "product-thumb")
      else
        "No image available"
      end
    end

    column :category
    column :created_at

    column "" do |business|
      content_tag(:span, "", class: "row-link", data: { href: admin_business_path(business) })
    end
  end

  show do |res|
    panel "Products", class: "fade-in-section" do
      products = if current_admin_user.seller?
                   res.products
                     .joins(:seller_products)
                     .where.not(seller_products: { seller_id: current_admin_user.id })
                     .distinct
                 else
                   res.products
                 end

      table_for products, class: "clickable-table" do
        column :image do |product|
          if product.image.attached?
            image_tag url_for(product.image), alt: product.name, style: "max-width: 300px;", class: "product-thumb", onclick: "event.stopPropagation(); highlightImage(this)"
          else
            "No image"
          end
        end

        column :name
        column :price
        column :brand_name
        column "Rating" do |product|
          product.rating || "Rating Not found"
        end

        column "view" do |product|
          span link_to("View Product", admin_product_path(product), class: "button cart-button")
        end
      end
    end
  end
end
