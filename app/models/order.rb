class Order < ApplicationRecord
  belongs_to :user, class_name: 'AdminUser'
  belongs_to :product
  belongs_to :seller, class_name: 'AdminUser'
end