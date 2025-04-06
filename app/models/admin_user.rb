class AdminUser < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  
  user_type = [ "admin", "user", "seller" ]
  USER_TYPES = user_type

  devise :database_authenticatable, 
         :recoverable, :rememberable, :validatable

   has_many :businesses, foreign_key: "seller_id", dependent: :destroy
   has_one :seller_product, foreign_key: "seller_id", dependent: :destroy
     has_many :orders_as_user, class_name: 'Order', foreign_key: 'user_id'
  has_many :orders_as_seller, class_name: 'Order', foreign_key: 'seller_id'
end
