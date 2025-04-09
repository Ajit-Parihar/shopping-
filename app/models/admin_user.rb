class AdminUser < ApplicationRecord
  
  user_type = [ "admin", "user", "seller" ]
  USER_TYPES = user_type

  devise :database_authenticatable, 
         :recoverable, :rememberable, :validatable

   has_many :businesses, foreign_key: "seller_id", dependent: :destroy
   has_one :seller_product, foreign_key: "seller_id", dependent: :destroy
     has_many :orders_as_user, class_name: 'Order', foreign_key: 'user_id'
  has_many :orders_as_seller, class_name: 'Order', foreign_key: 'seller_id'

  validates :password, :presence => true, :format => {:with => /\A[a-z0-9A-Z_@]{8,30}\Z/, message: :not_valid}, on: :create
  validates :password, {
      :presence => true, :format => {:with => /\A[a-z0-9A-Z_@]{8,30}\Z/, message: :not_valid },
      on: :update,
      if: :password_required?
  }

  validates :email, :presence => true, :format => {:with => /\A(?!.*?\.\.)[a-z0-9_+-\.]+[\.]*[a-z0-9_+-]+\@([-a-z0-9]+\.)+[a-z0-9]{2,6}\Z/i, message: :not_valid }
  validates :user_type, :presence => true, :inclusion => { :in => user_type }

  def admin?
    user_type == "admin"
  end

  def seller?
    user_type == "seller"
  end

  def user?
    user_type == "user"
  end

end
