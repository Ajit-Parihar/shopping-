class Transaction < ApplicationRecord
  acts_as_paranoid
  
  belongs_to :product
  belongs_to :seller, class_name: "AdminUser", foreign_key: "seller_id"

  validates :amount, presence: true
end
