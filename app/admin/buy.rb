# frozen_string_literal: true

ActiveAdmin.register_page "Buy" do
  menu false

  content title: "Buy" do
    product = Product.find(params[:product_id])
    status = params[:status]
    addresses = UserAddress.where(user_id: current_admin_user.id)

    if current_admin_user.seller?
        add_to_card = AddToCard.find_or_create_by(admin_user_id: current_admin_user.id, product_id: product.id) do |card|
        card.quantity = 1
      end
    end

    # if status == "true"
    #   div do
    #     raw <<-HTML
    #       <div id="success-animation" style="flex-direction: column; align-items: center; justify-content: center; height: 100%; width: 100%;">
    #         <div style="font-size: 4rem; color: green;">✅</div>
    #         <p style="color: green; font-weight: bold;">Your order has been placed!</p>
    #       </div>
    #     HTML
    #   end
    # end

    panel "Address" do
      form action: "/admin/some_action", method: :post do
        input type: "hidden", name: "authenticity_token", value: form_authenticity_token

        table_for addresses do
          column "Select" do |add|
            input type: "radio", name: "selected_address_id", value: add.id
          end
          column "Full Address", &:full_address
        end

        div style: "margin-top: 20px;" do
          link_to "Add Address", new_admin_user_address_path(product_id: product.id), class: "button primary"
        end
      end
    end

    if status == "false"
      div style: "margin-top: 20px;" do
        para "⚠️ Address is required before placing an order.",
             style: "color: red; font-weight: bold; margin-bottom: 10px;"
      end
    end

    panel "Product Detail" do
      table_for product do
        column :name
        column :brand_name

        column "Price" do |p|
          number_to_currency(p.price, unit: "₹")
        end

        column "Image" do |p|
          image_tag(p.image, style: "max-width: 100px;")
        end

        column "Quantity + Total" do |p|
          raw <<-HTML
            <div style="display: flex; align-items: center; gap: 10px;">
              <button class="decrease-btn" data-id="#{p.id}">➖</button>
              <span id="quantity-#{p.id}">1</span>
              <button class="increase-btn" data-id="#{p.id}">➕</button>
            </div>
            <div style="margin-top: 8px;">
              Total: ₹<span id="total-pay-#{p.id}" data-price="#{p.price}">#{p.price}</span>
            </div>
          HTML
        end

        column "Actions" do |p|
          link_to "Order Placed", "#", class: "button buy-button", data: { product_id: p.id }, onclick: "cardAddBuyProduct(this)"
        end
      end

      div do
        span "Grand Total: ₹ #{product.price}"
      end
    end
  end
end
