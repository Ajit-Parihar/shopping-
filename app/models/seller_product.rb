class SellerProduct < ApplicationRecord
  acts_as_paranoid
  
  belongs_to :product
  belongs_to :seller, class_name: 'AdminUser', foreign_key: 'seller_id' 
  belongs_to :business
end
