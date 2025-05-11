
ActiveAdmin.register_page "Buy" do
  menu false

  content title: "Buy" do
    product = Product.find(params[:product_id])
    status = params[:status]
    addresses = UserAddress.where(user_id: current_admin_user.id)
    
    addTocard = AddToCard.find_by(admin_user_id: current_admin_user.id, product_id: product.id)

    panel "Address" do

        table_for addresses do
          column "Select" do |add|
            checked = 'checked' if add.id.to_s == params[:selected_address_id].to_s
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
        column :name
        column :brand_name

        column "Price" do |p|
          number_to_currency(p.price, unit: "₹")
        end

        column "Image" do |p|
          image_tag(p.image, style: "max-width: 100px;")
        end

      #  puts addToCard
        if addTocard
        column "Quantity + Total" do |p|
          render partial: "admin/quantity_total", locals: { cart: addTocard }
        end
      end

        column "Actions" do |p|
          quantity = addTocard ? addTocard.quantity : 1
            link_to "Buy Now", buy_product_admin_product_path(p, quantity: quantity, address_id: params[:selected_address_id]), 
            method: :post, 
            data: { confirm: "Are you sure?" }, 
            class: "btn btn-success" 
        end
       end

      div do 
        if addTocard
        span "Quantity: #{addTocard.quantity}"
        br
        span "Grand Total: ₹ #{addTocard.quantity*product.price}"
        end
      end
    end
  end
end
