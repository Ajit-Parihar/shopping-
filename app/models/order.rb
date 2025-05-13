class Order < ApplicationRecord
  acts_as_paranoid

  belongs_to :user, class_name: 'AdminUser'
  belongs_to :product
  belongs_to :user_address, class_name: "UserAddress", foreign_key: "address_id"
  belongs_to :seller, class_name: 'AdminUser'
  belongs_to :business
  has_one :rating, dependent: :destroy 



  STATUS_TYPES = [
    "ordered",
    "processing",
    "shipped",
    "out_for_delivery",
    "delivered",
    "cancelled"
  ]

    STATUS_PROGRESS = {
      "ordered" => 0,
      "processing" => 20,
      "shipped" => 50,
      "out_for_delivery" => 80,
      "delivered" => 100,
      "cancelled" => 100
    }

    def self.create_order(user, product, quantity, address_id)
      seller_product = SellerProduct.find_by(product_id: product.id)
   
      order = Order.create(
        user_id: user.id,
        product_id: product.id,
        address_id: address_id,
        seller_id: seller_product.seller_id,
        business_id: product.business_id,
        quantity: quantity

      )
        transaction = Transaction.find_by(product_id: product.id)
        unless transaction
        transaction = Transaction.create(
        product_id: product.id,
        seller_id: seller_product.seller_id,
        amount: product.price
      )
       else
          transaction.update(amount: transaction.amount+product.price)
       end

      current_sold_count = seller_product.sold_count || 0
      seller_product.update(sold_count: current_sold_count + quantity)
  
      order
    end

  def progress_percentage
     case true
     when status_type == "cancelled"
      return calculate_progress(100)

     when Time.current >= created_at + 3.minutes
      update(status_type: "delivered")
      return calculate_progress(100)

     when Time.current >= created_at + 2.minutes
      update(status_type: "out_for_delivery")
      return calculate_progress(80)

     when Time.current >= created_at + 1.minutes
      update(status_type: "shipped")
      return calculate_progress(50)

     else
      update(status_type: "processing")
      return calculate_progress(20)
  end
end

def bar_color
  case status_type
  when "delivered"        then "#10b981"  
  when "cancelled"        then "#ef4444"  
  when "processing"       then "#3b82f6"   
  when "shipped"          then "#f59e0b"   
  when "out_for_delivery" then "#f97316"  
  else "#e5e7eb"                         
  end
end

  private
  def calculate_progress(progress)
    elapsed_time = Time.current - created_at
    max_time = 3.minutes
    percentage = [(elapsed_time / max_time) * progress, progress].min
    percentage.to_i
  end
end
