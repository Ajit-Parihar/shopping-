class Business < ApplicationRecord
    has_many :products
    has_many :orders
    has_many :seller_products
 
end
