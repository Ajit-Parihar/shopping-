ActiveAdmin.register_page "Buy" do
  menu false

  content title: "Buy" do
    product = Product.find(params[:product_id])
    status = params[:status]
    addresses = UserAddress.where(user_id: current_admin_user.id)
    addTocard = AddToCard.find_by(admin_user_id: current_admin_user.id, product_id: product.id)
    selected_address = nil 

    panel "Address" do
      table_for addresses do
        column "Select" do |add|
          if add.id.to_s == params[:selected_address_id].to_s
            selected_address = params[:selected_address_id].to_s
            checked = 'checked' 
          elsif addresses.count == 1
            checked = "checked"
            selected_address = add.id.to_s
          end

          input type: "radio", name: "selected_address_id", value: add.id, checked: checked
        end
        column "Full Address", &:full_address
      end

      div style: "margin-top: 20px;" do
        link_to "Add Address", new_admin_user_address_path(product_id: product.id), class: "button primary"
      end
    end

    panel "Product Detail" do
      table_for product do
        column "Image" do |p|
          if p.image.attached?
            image_tag(p.image, style: "max-width: 100px;")
          else
            "Image not found" 
          end
        end

        column :name
        column :brand_name

        column "Price" do |p|
          number_to_currency(p.price, unit: "₹")
        end

        if addTocard
          column "Quantity + Total" do |p|
            render partial: "admin/quantity_total", locals: { cart: addTocard }
          end
        end

        column "Actions" do |p|
          quantity = addTocard ? addTocard.quantity : 1
          link_to "Buy Now", buy_product_admin_product_path(p, quantity: quantity, address_id: selected_address),
            method: :post,
            data: { confirm: "Are you sure?" },
            class: "btn btn-success"
        end
      end

      div do
        if addTocard
          span "Quantity: #{addTocard.quantity}"
          br
          span "Grand Total: ₹ #{addTocard.quantity * product.price}"
        end
      end
    end
  end
end
