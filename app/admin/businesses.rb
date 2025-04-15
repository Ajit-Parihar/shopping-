ActiveAdmin.register Business do
  permit_params :category, :created_at, :updated_at

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

  controller do
    def scoped_collection
      if current_admin_user.admin? || current_admin_user.user?
        Business.joins(:products).distinct
      else
        Business.joins(:products)
                .joins("INNER JOIN seller_products ON seller_products.business_id = businesses.id")
                .where(seller_products: { seller_id: current_admin_user.id })
                .distinct
      end
    end
  end

  filter :category

  index row_class: ->(business) { "clickable-row" } do
    selectable_column
    id_column

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
  end

  show do |res|
    panel "Products", class: "fade-in-section" do

      table_for res.products, class: "clickable-table" do
        column :id
        column :name
        column :price
        column :brand_name

        column "Rating" do |product|
          product.rating || "Rating Not found"
        end

        column :image do |product|
          if product.image.attached?
            image_tag url_for(product.image), alt: product.name, style: "max-width: 300px;", class: "product-thumb", onclick: "event.stopPropagation(); highlightImage(this)"
          else
            "No image"
          end
        end
      end
    end
  end
end
