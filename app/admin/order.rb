ActiveAdmin.register Order do
  permit_params :user_id, :product_id, :seller_id, :business_id

  controller do
    def scoped_collection
      if current_admin_user.admin?
        Order.where(id: Order.select("MIN(id)").group(:product_id))
      else
        seller_orders = Order.where(seller_id: current_admin_user.id)
        Order.where(id: seller_orders.select("MIN(id)").group(:product_id))
      end
    end
  end

  form do |f|
    f.inputs "Create Order" do
      f.input :user_id,
              label: "Buyer",
              as: :select,
              collection: AdminUser.where(user_type: [ "user", "seller" ])
                                   .where.not(id: current_admin_user.id)
                                   .map { |u| [ u.email, u.id ] }

      f.input :product_id,
              as: :select,
              collection: Product.all.map { |p| [ "#{p.name} (#{p.brand_name})", p.id ] }

      f.object.seller_id = current_admin_user.id

      f.input :business_id,
              as: :select,
              collection: Business.all.map { |b| [ b.category, b.id ] }
    end
    f.actions
  end

  filter :business,
         as: :select,
         collection: -> {
           if current_admin_user.admin?
             Business.all.map { |b| [ b.category, b.id ] }
           else
             Business.where(seller_id: current_admin_user.id)
                     .map { |b| [ "Business (#{b.category})", b.id ] }
           end
         },
         label: "Business Name"

  index do |res|
    paramsbusiness = params[:business_id]
    flag = false

    orders.each do |order|
      product = Product.find(order.product.id)
      if paramsbusiness.nil? || paramsbusiness.to_i == product.business_id
        flag = true
      end
    end

    if current_admin_user.admin?
      selectable_column
      column "Product Name" do |order|
        order.product&.name
      end
      column "Product Price" do |order|
        order.product&.price
      end
      actions defaults: false do |product|
        item "View", admin_product_path(product), class: "view_link member_link"
      end
    else
      if flag
        selectable_column
        column "Product Name" do |order|
          product = Product.find(order.product_id)
          business = product.business_id

          if paramsbusiness.to_i == business
            product.name
          elsif paramsbusiness.nil? && order.seller_id == current_admin_user.id
            product.name
          end
        end
        column "Product Price" do |order|
          product = Product.find(order.product_id)
          business = product.business_id

          if paramsbusiness.to_i == business
            product.price
          elsif paramsbusiness.nil? && order.seller_id == current_admin_user.id
            product.price
          end
        end
        actions
      end
    end
  end
  show do
    if current_admin_user.admin?
      order_id = Order.find(params[:id])
      all_orders = Order.where(product_id: order_id.product_id)

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
    else
      all_orders = Order.where(seller_id: current_admin_user.id)
      panel "Total buyers have purchased this product" do
        table_for all_orders do
          column "Name" do |order|
            order.user.first_name+" "+order.user.last_name
          end
          column "User" do |order|
            order.user.email
          end
          column "Ordered At" do |order|
            order.created_at.strftime("%B %d, %Y %H:%M")
          end
        end
      end
    end
  end
end
