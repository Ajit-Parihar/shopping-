ActiveAdmin.register_page "OrderTracker" do
  menu false

  content title: "Order Progress Overview" do
    if params[:order_id].present?
      begin
        order = Order.find(params[:order_id])

        panel "Order Progress Overview" do
          percentage = order.progress_percentage
          color = case order.status_type
                  when "delivered"        then "#10b981"  
                  when "cancelled"        then "#ef4444" 
                  when "processing"       then "#3b82f6" 
                  when "shipped"          then "#f59e0b"  
                  when "out_for_delivery" then "#f97316"  
                  else "#e5e7eb"                    
                  end

          div style: "margin-bottom: 20px;" do
            h4 "Order ##{order.id} - #{order.status_type.humanize}"

            div style: "display: flex; justify-content: space-between;" do
              span style: "font-weight: bold; color: #{color};" do
                order.status_type.humanize
              end
            end

            div style: "width: 100%; background-color: #e5e7eb; border-radius: 5px; overflow: hidden;" do
              div style: "width: #{percentage}%; background-color: #{color}; height: 20px; transition: width 1s ease;" do
              end
            end

            para "#{percentage}% Complete"
          end
        end

      rescue ActiveRecord::RecordNotFound
        para "Order not found. Please check the order ID and try again."
      end
    else
      para "No order ID provided."
    end
  end
end
