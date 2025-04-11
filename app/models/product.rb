class Product < ApplicationRecord
  belongs_to :business
  has_many :seller_products
  has_many :orders
  has_many :add_to_cards
  has_many :ratings
  has_one_attached :image
end
