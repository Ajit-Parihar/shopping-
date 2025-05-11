ActiveAdmin.register_page "OrderTracker" do
  menu false
  content title: "Order Progress Overview" do
    if params[:order_id].present?
      begin
        order = Order.find(params[:order_id])

        panel "Order Progress Overview" do
          percentage = order.progress_percentage
          color = order.bar_color
        
          div style: "margin-bottom: 20px;" do
            div style: "margin-bottom: 10px;" do
              if order.rating
                link_to "Edit Rating", edit_admin_rating_path(order.rating), class: "button"
              end
            end
        
            div style: "display: flex; justify-content:" do
              div style: "display: flex; flex-direction: column; justify-content: space-around; padding-top: 13px" do
              span style: "font-weight: bold; color: #10b981;" do
                "Ordered"
              end
              
              span style: "font-weight: bold; color: #3b82f6;" do
              "Processing"
               end

               span style: "font-weight: bold; color: #f59e0b;" do
               "Shipped"
              end

              span style: "font-weight: bold; color: #f97316;" do
               "Out for delivery"
                end

               span style: "font-weight: bold; color: #10b981;" do
                "Delivered"
               end

               span style: "font-weight: bold; color: #ef4444;" do
               "Cancelled"
               end
            end
            
            div style: " height: 275px; width: 20px; background-color: #e5e7eb; border-radius: 5px; overflow: hidden; margin-top: 10px;" do
            div style: "width: 100%; height: #{percentage}%; background-color: #{color}; transition: height 1s ease;" do
            end
            end
              h4 style: " padding-left: 20px; color: #{color}; padding-right: 20px" do
               "Order #{order.status_type}"
             end

             panel "deliver product Details" do 
                  table_for order.product do 
                       column :name
                       column :brand_name

                       column "Rating" do |product|
                        product.rating || "Rating Not found"
                     end

                       column "Price" do |p|
                        number_to_currency(p.price, unit: "₹")
                      end
                      column "Image" do |p|
                        link_to admin_product_path(p.id) do
                          image_tag(p.image, style: "max-width: 100px;")
                        end
                      end
                      
                  end
             end
          end
        end
      end
      end        
    else
      para "No order ID provided."
    end
  end
end
