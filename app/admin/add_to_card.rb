ActiveAdmin.register_page "AddToCard" do
  menu false

  content title: "Add To Card" do
    product = Product.find(params[:product_id])

    if current_admin_user.seller?
      add_to_card = AddToCard.find_by(admin_user_id: current_admin_user.id, product_id: product.id)
      unless add_to_card
        add_to_card = AddToCard.create(quantity: 1, admin_user_id: current_admin_user.id, product_id: product.id)
        add_to_card.save
      end
    end

    panel "Product Detail" do
      table_for product do
        column "Name"

        column "Brand"

        column "Price" do |product|
          number_to_currency(product.price, unit: "₹")
        end

        column "Image" do |product|
          image_tag(product.image, style: "max-width: 100px;")
        end

        column "Quantity + Total" do |product|
          raw <<-HTML
            <div style="display: flex; align-items: center; gap: 10px;">
              <button class="decrease-btn" data-id="#{product.id}">➖</button>
              <span id="quantity-#{product.id}">1</span>
              <button class="increase-btn" data-id="#{product.id}">➕</button>
            </div>
            <div style="margin-top: 8px;">
              Total: ₹<span id="total-pay-#{product.id}" data-price="#{product.price}">#{product.price}</span>
            </div>
          HTML
        end

        column "Actions" do |product|
          link_to "Buy", "#", class: "button buy-button", data: { product_id: product.id }, onclick: "cardAddBuyProduct(this)"
        end
      end

      div do
        span "Grand Total: ₹"
        span id: "grand-total" do
          product.price.to_s
        end
      end
    end
  end
end
