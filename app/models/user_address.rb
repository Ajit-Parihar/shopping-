class UserAddress < ApplicationRecord
  belongs_to :user, class_name: "AdminUser"

  def full_address
    [
      house_no, "Gali No. #{gali_no}", town, block, dist, state, country
    ].compact.join(", ")
  end
end