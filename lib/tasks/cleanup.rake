namespace :cleanup do
  desc "Permanently delete soft-deleted products older than 30 days"
  task old_soft_deleted_products: :environment do
    cutoff_time = 1.minutes.ago  
      Product.only_deleted.where('deleted_at < ?', cutoff_time).find_each do |product|
      product.really_destroy!
    end
    puts "Old soft-deleted products permanently removed."
  end
end
