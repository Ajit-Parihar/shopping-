namespace :cleanup do
  desc "Permanently delete soft-deleted products older than 30 days"
  task old_soft_deleted_items: :environment do
    cutoff_time = 30.minutes.ago  
    Product.only_deleted.where('deleted_at < ?', cutoff_time).find_each do |product|
 
      # product.seller_products.find_each(&:destroy)
      # product.orders.find_each(&:destroy)
      # product.add_to_cards.find_each(&:destroy)
      # product.ratings.find_each(&:destroy)
      # product.transactions.find_each(&:destroy)

  
      product.really_destroy!
    end
    puts "Old soft-deleted products permanently removed."
  end
end
