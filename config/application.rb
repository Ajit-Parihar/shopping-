require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module BusinessManagement2
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.0

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    config.images_hash = {
      Electronic: "https://fndsuk.files.wordpress.com/2020/06/make-a-note-on-consumer-electronics-awesome-things-learn-electronic-appliances-for-home-1024x768-1.jpg",
      Cloth: "https://pluspng.com/img-png/shirt-png-hd-dress-shirt-png-image-dress-shirt-png-914.png",
      Food: "https://img.freepik.com/premium-vector/food-grocery-store-shopping-illustration-with-foods-items-product-assortiment-supermarket_2175-15923.jpg",
      Decoration: "https://rukminim2.flixcart.com/image/850/1000/xif0q/wall-decoration/g/g/k/wooden-wall-hanging-art-decoration-item-for-home-wall-decor-item-original-imagsyuaexrzar5y.jpeg?q=20&crop=false",
      Fashion: "https://img.freepik.com/premium-photo/collection-leather-items-including-one-that-has-word-leather-it_1276068-13915.jpg",
      Jewelry: "https://m.media-amazon.com/images/I/51j1-PZbIBL._AC_UY300_.jpg",
      Book: "https://img.freepik.com/free-vector/hand-drawn-flat-design-stack-books-illustration_23-2149341898.jpg"
    }


    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
  end
end
