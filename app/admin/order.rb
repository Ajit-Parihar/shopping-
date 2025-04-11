ActiveAdmin.register Order do
  
  permit_params :user_id, :product_id, :seller_id, :business_id

  if proc { current_admin_user.admin? || current_admin_user.seller? }
    actions :index, :show, :new, :create
  else
    actions :show
  end
  controller do
    def index
      unless current_admin_user.admin? || current_admin_user.seller?
        order = Order.find_by(user_id: current_admin_user.id)
        puts 'working orders '
       
        unless order == nil
        redirect_to admin_order_path(order.id)  #some change are needed
        else
          redirect_to admin_root_path, alert: "You have not purchased anything on this platform."

        end
      else
        super
      end
    end

    def scoped_collection

      if current_admin_user.admin?
        Order.where(id: Order.select("MIN(id)").group(:product_id))
      elsif current_admin_user.seller?
        seller_orders = Order.where(seller_id: current_admin_user.id)
        Order.where(id: seller_orders.select("MIN(id)").group(:product_id))
      else
          Order.where(user_id: current_admin_user.id).group(:product_id)
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

         index do 
           selectable_column 
             column "Product Name" do |order|
                order.product&.name
             end

             column "Product Price" do |order|
              number_to_currency(order.product&.price, unit: "₹", precision: 0)
            end 

            # actions defaults: false do |order|
            #   link_to 'View', resource_path(order)
            # end
            
            actions
        end

  show do
    if current_admin_user.admin?
      order_id = Order.find(params[:id])
      all_orders = Order.where(product_id: order_id.product_id)

      panel "Total buyers have purchased this product" do
        table_for all_orders do
          column "Buyer" do |order|
            order.user.first_name
          end
          column "Ordered At" do |order|
            order.created_at.strftime("%B %d, %Y %H:%M")
          end
          column "Seller" do |order|
            order.seller.first_name
          end
        end
      end
    elsif current_admin_user.seller?
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
    else
      
      all_orders = Order.where(user_id: current_admin_user.id)
      panel "Total buyers have purchased this product" do
        table_for all_orders do
          column "prdouct" do |order|
             image_tag(order.product.image,  class: "product-thumb",)
          end
          column "Buyer" do |order|
            order.user.first_name
          end
          column "Ordered At" do |order|
            order.created_at.strftime("%B %d, %Y %H:%M")
          end
          column "Seller" do |order|
            order.seller.first_name
          end
         
          column "deliver status" do |order|
            if order.cancel == false
              order.delivered?
            else
               "Order is Cancel"
            end
          end
          column "Order Confirm" do |order|
            order.pending
          end

           column "rating" do |order|
            if resource.delivered? && order.cancel == false

              link_to "Add Rating", "#", onclick: "productRating(this)", class: "button primary", data: { id: order.id }           
             end
          end
          column "Cancel Order" do |order|
            unless order.delivered? || order.cancel
              link_to "Cancel", "#", onclick: "cancelOrder(this)", class: "button primary", data: { id: order.id }           
             end
          end
        end
      end
    end
  end

  member_action :cancel_order, method: :post do
      order = Order.find(params[:id])
      order.update(cancel: true)
      render json:{message: "Order cancel succssfully"}
  end
end
