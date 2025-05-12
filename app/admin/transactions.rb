ActiveAdmin.register Transaction do
   permit_params :seller_id, :product_id, :amount
   config.batch_actions =false
   filter :product

   controller do 
     def scoped_collection
         Transaction.where(seller_id: current_admin_user.id)
     end
   end
   index do
      selectable_column
      column :image do |t|
        if t.product.image.attached?
          image_tag url_for(t.product.image), alt: t.product.name, style: "max-width: 300px;", class: "product-thumb", onclick: "highlightImage(this)"
        else
           "No Image"
        end
   end

   column "Product Name" do |t|
      t.product.name
   end

   column "Brand Name" do |t|
     t.product.brand_name
   end

   column "Rating" do |t|
    t.product.rating || "Rating Not Fount"
   end

   column "Price" do |t|
      t.product.price
   end 
   actions
  end

  show do |res|
    panel "Product Transaction details" do
      table_for res do
      column :image do |res|
        if res.product.image.attached?
          image_tag url_for(res.product.image), alt: res.product.name, style: "max-width: 300px;", class: "product-thumb", onclick: "highlightImage(this)"
        else
           "No Image"
        end
      end
      column "Product Name" do |res|
        res.product.name
      end
      column "Brand Name" do |res|
         res.product.brand_name
      end

      column "Rating" do |res|
        res.product.rating || "Rating Not Fount"
       end
    end
    end
    orders = Order.where(product_id: resource.product_id, seller_id: resource.seller_id)
     table_for orders do 
         column "user" do |order| 
          order.user.first_name + " " + order.user.last_name
         end
        
         column "deliver" do |order|
          (order.created_at + 3.days).strftime("%d %b %Y")         
        end

        column "Buy Quantity" do |order|
            order.quantity
        end

         column "Transaction" do |order|
             order.product.price * order.quantity
         end

         column "deliver Address" do |order|
             order.user_address.full_address
         end
        end

        total_transaction = orders.sum { |order| order.product.price * order.quantity }

        div style: "margin-top: 20px; font-weight: bold;" do
          span "Total Transaction: ₹ #{total_transaction}"
        end
        
   end
end
