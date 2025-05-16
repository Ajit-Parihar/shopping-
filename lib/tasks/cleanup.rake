namespace :cleanup do
  desc "Permanently delete soft-deleted products older than 30 days"
  task old_soft_deleted_products: :environment do
    cutoff_time = 1.minute.ago

    Rating.only_deleted.where('deleted_at < ?', cutoff_time).find_each do |rating|
      rating.really_destroy!
   end

    Product.only_deleted.where('deleted_at < ?', cutoff_time).find_each do |product|
      product.really_destroy!
    end

    Order.only_deleted.where('deleted_at < ?', cutoff_time).find_each do |order|
      order.really_destroy!
    end

    AddToCard.only_deleted.where('deleted_at < ?', cutoff_time).find_each do |addToCard|
      addToCard.really_destroy!
    end

    UserAddress.only_deleted.where('deleted_at < ?', cutoff_time).find_each do |userAddress|
        userAddress.really_destroy!
    end

    puts "Old soft-deleted products permanently removed."
  end
end
