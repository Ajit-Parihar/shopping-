class UserAddress < ApplicationRecord
  acts_as_paranoid

  belongs_to :user, class_name: "AdminUser"
  has_many :orders, foreign_key: "address_id"

  def full_address
    [
      house_no, "Gali No. #{gali_no}", town, block, dist, state, country
    ].compact.join(", ")
  end
  
validates :dist, presence: { message: "District is required" },
                 format: { with: /\A[a-zA-Z]{2,20}\z/, message: "District must be 2-20 alphabetic characters" }

validates :block, presence: { message: "Block is required" },
                  format: { with: /\A[a-zA-Z]{2,20}\z/, message: "Block must be 2-20 alphabetic characters" }

validates :town, presence: { message: "Town is required" },
                 format: { with: /\A[a-zA-Z]{2,20}\z/, message: "Town must be 2-20 alphabetic characters" }

validates :gali_no, presence: { message: "Gali Number is required" },
                    format: { with: /\A[0-9]{1,3}\z/, message: "Gali Number must be 1-3 digits" }

validates :house_no, presence: { message: "House Number is required and it is Number" },
                     format: { with: /\A[0-9]{1,3}\z/, message: "House Number must be 1-3 digits" }
end