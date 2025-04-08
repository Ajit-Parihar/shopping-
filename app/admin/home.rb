
ActiveAdmin.register_page "Home" do  

  content title: "Home" do

    # skip_before_action :authenticate_active_admin_user!

      businesses = Business.all

      panel "Category list" do
        table_for businesses do
          column "Category" do |business|
              content_tag(:div, business.category, style: "width: 100%; height: 100%;")
          end
          
          column "Seller" do |business|
            if business.seller
              "#{business.seller.first_name} #{business.seller.last_name}"
            else
              status_tag "No Seller", :warning
            end
          end
          column :image do |business|
            category = business.category
            image_url = Rails.application.config.images_hash[category.to_sym] if Rails.application.config.images_hash.key?(category.to_sym)
      
            if image_url
                image_tag(image_url, alt: "#{category} Image", style: "max-width: 300px;", class: "product-thumb", onclick: "highlightImage(this)" )
            else
              "No image available"
            end
          end
        end
      end
   end
end
