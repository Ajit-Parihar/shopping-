# frozen_string_literal: true
ActiveAdmin.register_page "Buy" do
  menu false
  content  title: "Buy" do
    product = Product.find(params[:product_id])
    status = params[:status]
    addresses = UserAddress.where(user_id: current_admin_user.id)
    if current_admin_user.seller?
      add_to_card = AddToCard.find_by(admin_user_id: current_admin_user.id, product_id: product.id)
      unless add_to_card
        add_to_card = AddToCard.create(quantity: 1, admin_user_id: current_admin_user.id, product_id: product.id)
        add_to_card.save
      end
    end
    
    if status == "true"
      div do
        raw <<-HTML
          <div id="success-animation" style="flex-direction: column; align-items: center; justify-content: center; height: 100%; width: 100%;">
            <div style="font-size: 4rem; color: green;">✅</div>
            <p style="color: green; font-weight: bold;">Your order has been placed!</p>
          </div>
        HTML
      end
    end
    
    panel "Address" do
      form action: "/admin/some_action", method: :post do |f|
        input type: "hidden", name: "authenticity_token", value: form_authenticity_token
    
        table_for addresses do
          column "Select" do |add|
            input type: "radio", name: "selected_address_id", value: add.id
          end
          column "Full Address" do |add|
            add.full_address
          end
        end
        div style: "margin-top: 20px;" do
          link_to "Add Address",  new_admin_user_address_path(product_id: product.id), class: "button primary" 
          end
      end
    end
    

    div style: "margin-top: 20px;" do
      if status == "false"
        para "⚠️ Address is required before placing an order.", 
             style: "color: red; font-weight: bold; margin-bottom: 10px;"
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
            link_to "Order Placed", "#", class: "button buy-button", data: { product_id: product.id }, onclick: "cardAddBuyProduct(this)"
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
