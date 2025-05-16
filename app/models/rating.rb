class Rating < ApplicationRecord
  acts_as_paranoid

  belongs_to :admin_user
  belongs_to :product
  has_many_attached :photos
  belongs_to :order

 validates :rate,
            presence: { message: "Rating can't be blank" },
            numericality: {
              only_integer: true,
              greater_than: 0,
              less_than_or_equal_to: 5,
              message: "Rating must be between 1 and 5"
            }
            
            validates :comments,
            length: { minimum: 10, message: "Comment must be at least 10 characters" },
            allow_blank: true

            validate :photos_format, if: -> { photos.attached? }
       private
            
            def photos_format
              photos.each do |photo|
                if !photo.content_type.in?(%w[image/png image/jpg image/jpeg])
                  errors.add(:photos, "must be a PNG, JPG, or JPEG file")
                elsif photo.byte_size > 5.megabytes
                  errors.add(:photos, "should be less than 5MB")
                end
              end
            end

  after_save :update_product_average_rating

  private

  def update_product_average_rating
    all_ratings = product.ratings.pluck(:rate)
    avg_rating = all_ratings.sum.to_f / all_ratings.size
    product.update(rating: avg_rating.round(1))
  end

end
