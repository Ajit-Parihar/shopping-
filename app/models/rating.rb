class Rating < ApplicationRecord
  belongs_to :admin_user
  belongs_to :product
  has_many_attached :photos
end
