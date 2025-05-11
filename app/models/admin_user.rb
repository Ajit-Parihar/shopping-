class AdminUser < ApplicationRecord
  acts_as_paranoid

  user_type = [ "admin", "user", "seller" ]
  USER_TYPES = user_type

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

         has_one :seller_product, foreign_key: "seller_id", dependent: :destroy
         has_many :orders_as_user, class_name: 'Order', foreign_key: 'user_id', dependent: :destroy
         has_many :orders_as_seller, class_name: 'Order', foreign_key: 'seller_id', dependent: :destroy
         has_many :ratings, dependent: :destroy
         has_many :user_addresses, foreign_key: 'user_id', dependent: :destroy
         has_many :transactions, foreign_key: 'seller_id', dependent: :destroy
         has_many :add_to_cards, dependent: :destroy

         def restore_with_dependents
          restore
        
          ratings.only_deleted.each(&:restore)
          user_addresses.only_deleted.each(&:restore)
          orders_as_user.only_deleted.each(&:restore)
          orders_as_seller.only_deleted.each(&:restore)
          transactions.only_deleted.each(&:restore)
          add_to_cards.only_deleted.each(&:restore)
          seller_product&.restore
        end

# First name
validates :first_name,
  presence: { message: "First name is required" },
  format: { with: /\A[a-zA-Z]{2,20}\z/, message: "First name must be 2-20 alphabetic characters" }

# Last name
validates :last_name,
  presence: { message: "Last name is required" },
  format: { with: /\A[a-zA-Z]{2,20}\z/, message: "Last name must be 2-20 alphabetic characters" }

# Password
validates :password,
  presence: { message: "Password is required" },
  format: { with: /\A[a-zA-Z0-9_@]{8,30}\z/, message: "Password must be 8-30 characters using letters, numbers, _ or @" },
  on: :create

validates :password, {
  presence: { message: "Password is required" },
  format: { with: /\A[a-zA-Z0-9_@]{8,30}\z/, message: "Password must be 8-30 characters using letters, numbers, _ or @" },
  on: :update,
  if: :password_required?
}

# Email
validates :email,
  presence: { message: "Email is required" },
  format: { with: /\A(?!.*?\.\.)[a-z0-9_+\-.]+@[a-z0-9\-]+(\.[a-z0-9]{2,6})+\z/i, message: "Email format is invalid" }

# User type
validates :user_type,
  presence: { message: "User type is required" },
  inclusion: { in: user_type, message: "User type must be one of: #{user_type.join(', ')}" }

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