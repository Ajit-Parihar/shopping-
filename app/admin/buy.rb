
ActiveAdmin.register_page "Buy" do
  menu false

  content title: "Buy" do
    product = Product.find(params[:product_id])
    status = params[:status]
    addresses = UserAddress.where(user_id: current_admin_user.id)

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
          render partial: "admin/quantity_total", locals: { product: product }
        end

        column "Actions" do |p|
          link_to "Buy Now", buy_product_admin_product_path(product, quantity: 1),  
           method: :post, 
           data: { confirm: "Are you sure?" }, 
           class: "btn btn-success" 
         end
       end

      div do
        span "Grand Total: ₹ #{product.price}"
      end
    end
  end
end
