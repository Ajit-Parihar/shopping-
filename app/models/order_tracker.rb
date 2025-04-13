class OrderTracker < ApplicationRecord
  enum status: {
    ordered: 0,
    processing: 1,
    shipped: 2,
    out_for_delivery: 3,
    delivered: 4,
    cancelled: 5
  }

  belongs_to :user, class_name: 'AdminUser'
end

