class Order < ApplicationRecord
  belongs_to :user, class_name: 'AdminUser'
  belongs_to :product
  belongs_to :seller, class_name: 'AdminUser'
  belongs_to :business


  def delivered?
    Time.current >= created_at + 2.minutes
  end
end