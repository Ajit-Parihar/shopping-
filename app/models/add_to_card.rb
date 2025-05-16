class AddToCard < ApplicationRecord
  acts_as_paranoid
  
  belongs_to :admin_user
  belongs_to :product
end
