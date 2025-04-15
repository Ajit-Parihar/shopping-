class Product < ApplicationRecord
  belongs_to :business
  has_many :seller_products
  has_many :orders
  has_many :add_to_cards
  has_many :ratings
  has_one_attached :image


  after_create :create_seller_product

  private

  def create_seller_product

    return unless Current.admin_user&.user_type == "seller"

    SellerProduct.create(
      seller_id: Current.admin_user.id,
      product_id: self.id,
      business_id: self.business_id
    )
  end
end
