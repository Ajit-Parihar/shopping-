class Product < ApplicationRecord
  belongs_to :business
  has_many :seller_products
  has_many :orders
  has_one_attached :image
end
