class SellerProduct < ApplicationRecord
  belongs_to :product
  belongs_to :seller, class_name: 'AdminUser', foreign_key: 'seller_id' 
end
