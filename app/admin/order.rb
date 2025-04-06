
ActiveAdmin.register Order do

  controller do
    def scoped_collection
      if current_admin_user
        Order.all
        Order.where(id: Order.select("MIN(id)").group(:product_id))
      else
         Order.where(seller_id: current_admin_user)
         Order.where(id: Order.select("MIN(id)").group(:product_id))
      end
    end
  end

  filter :name
  filter :brand_name
  filter :business, as: :select, collection: -> {
    if current_admin_user.user_type == 'admin'
      Business.all.map { |b| [b.category, b.id] }
    else
      Business.where(seller_id: current_admin_user.id).map { |b| ["Business (#{b.category})", b.id] }
    end
  }, label: "Business Name"
 

index do
   paramsbusiness = params[:business_id]
   flag = false
   orders.each do |order|
     product = Product.find(order.product.id)
     puts product.business_id.inspect
     if paramsbusiness==nil
        flag = true
     end
     if paramsbusiness.to_i == product.business_id
          flag = true
     end
   end
   if flag
   selectable_column
   column "Product Name" do |order|
     product = Product.find(order.product_id)
     business = product.business_id
  
       if paramsbusiness.to_i == business
            Product.find(order.product_id).name
       else
        if paramsbusiness == nil&& current_admin_user
          if order.seller_id == current_admin_user.id
            Product.find(order.product_id).name
          end
        end
       end
    end
     column "Product Price" do |order|
      product = Product.find(order.product_id)
      business = product.business_id
        if paramsbusiness.to_i == business
            Product.find(order.product_id).price
          else 
            if paramsbusiness == nil && current_admin_user
              if order.seller_id == current_admin_user.id
                Product.find(order.product_id).price
              end
            end
          end
        end
   actions
  end
end

show do
user = AdminUser.find(order.user_id) 
all_orders = Order.where(seller_id: current_admin_user.id) 

panel "Total buyers have purchased this product" do
  table_for all_orders do
    column "User" do |order|
      order.user.email
    end
    column "Ordered At" do |order|
      order.created_at.strftime("%B %d, %Y %H:%M")
    end
    column "Seller" do |order|
        order.seller.email
    end
  end
end
end
end
