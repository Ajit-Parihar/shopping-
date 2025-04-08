class AddToCard < ApplicationRecord
  belongs_to :adminuser
  belongs_to :product
end
