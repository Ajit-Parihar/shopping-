ActiveAdmin.register_page "SellerDashboard" do
  menu false

  content title: "Seller Dashboard" do

    columns do
      column do 
        panel "Your Businesses", class: "scrollable-panel" do 
          businesses = Business
         .joins("INNER JOIN seller_products ON seller_products.business_id = businesses.id")
         .joins("INNER JOIN products ON products.id = seller_products.product_id")
         .where(seller_products: { seller_id: current_admin_user.id })
         .where(products: { deleted_at: nil })
         .distinct

        render partial: "seller/business", locals: { businesses: businesses }
        end
      end

      column do
        panel "Your Products", class: "scrollable-panel" do
products = Product.with_deleted
  .joins("LEFT JOIN seller_products ON seller_products.product_id = products.id AND seller_products.deleted_at IS NULL OR seller_products.deleted_at IS NOT NULL")
  .where("seller_products.seller_id = ?", current_admin_user.id)
  .distinct


            puts "print products"
            puts products.inspect

          render partial: "seller/product", locals: { products: products }
        end
      end
    end

    columns do
      column do
        panel "Your Orders", class: "scrollable-panel" do
          orders = Order.where(seller_id: current_admin_user.id)
          render partial: "seller/order", locals: { orders: orders }
        end
      end

      column do
        panel "Your Transactions", class: "scrollable-panel" do
          transactions = Transaction.where(seller_id: current_admin_user.id)
          render partial: "seller/transaction", locals: { transactions: transactions }
        end
      end
    end
  end
end
  