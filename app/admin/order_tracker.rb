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
              link_to "Edit Rating", edit_admin_rating_path(order.rating), class: "button"
            end
        
            h4 "Order ##{order.id} - #{order.status_type.humanize}"
        
            div style: "display: flex; justify-content: space-between;" do
              span style: "font-weight: bold; color: #{color};" do
                order.status_type.humanize
              end
            end
        
            div style: "display: flex; align-items: flex-end; height: 200px; width: 20px; background-color: #e5e7eb; border-radius: 5px; overflow: hidden; margin-top: 10px;" do
              div style: "height: #{percentage}%; width: 100%; background-color: #{color}; transition: height 1s ease;" do
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
