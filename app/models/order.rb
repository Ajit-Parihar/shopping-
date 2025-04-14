class Order < ApplicationRecord
  belongs_to :user, class_name: 'AdminUser'
  belongs_to :product
  belongs_to :seller, class_name: 'AdminUser'
  belongs_to :business
  has_many :ratings

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


  def progress_percentage
    if Time.current >= created_at + 3.minutes
      update(status_type: "delivered")
      return calculate_progress(100)
  
    elsif Time.current >= created_at + 2.minutes
      update(status_type: "out_for_delivery")
      return calculate_progress(80)
  
    elsif Time.current >= created_at + 1.minutes
      update(status_type: "shipped")
      return calculate_progress(50)
  
    else
      update(status_type: "processing")
      return calculate_progress(20)
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
