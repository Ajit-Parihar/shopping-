class Product < ApplicationRecord
  acts_as_paranoid

  belongs_to :business
  
  has_many :seller_products, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_many :add_to_cards, dependent: :destroy
  has_many :ratings, dependent: :destroy
  has_many :transactions, dependent: :destroy
  has_one_attached :image

  
  def restore_with_dependents
    restore
  
    orders.only_deleted.each(&:restore)
    ratings.only_deleted.each(&:restore)
    add_to_cards.only_deleted.each(&:restore)
    transactions.only_deleted.each(&:restore)
    seller_products.only_deleted.each(&:restore)
  end

  validates :name, presence: { message: "Product name can't be blank." }, 
                   length: { in: 3..100, message: "Product name must be between 3 and 100 characters." }

  validates :price, presence: { message: "Price can't be blank." },
                    numericality: { greater_than_or_equal_to: 0, message: "Price must be a positive number." }

  validates :brand_name, presence: { message: "Brand name can't be blank." },
                         length: { in: 2..50, message: "Brand name must be between 2 and 50 characters." }

  validates :discription, presence: { message: "Description can't be blank." },
                          length: { maximum: 500, message: "Description can't exceed 500 characters." }

  validates :business_id, presence: { message: "Product category must be selected." }


  validate :image_presence_and_format

private

def image_presence_and_format
  if image.attached?
    if !image.content_type.in?(%w[image/png image/jpg image/jpeg])
      errors.add(:image, "must be a PNG, JPG, or JPEG file.")
    elsif image.byte_size > 5.megabytes
      errors.add(:image, "should be less than 5MB.")
    end
  else
    errors.add(:image, "must be attached.")
  end
end

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
