ActiveAdmin.register Rating do
  menu false
  remove_filter :photos_attachments, :photos_blob

  permit_params :comments, :rate, :admin_user_id, :product_id, :order_id, photos: []

  controller do
    def new
      @rating = Rating.new

      if params[:order_id].present?
        order = Order.find_by(id: params[:order_id])
        if order
          @rating.product_id = order.product_id
          @rating.admin_user_id = order.user_id
          @rating.order_id = order.id
        end
        puts "Initializing new rating:"
        puts @rating.inspect
      end
      super
    end

    def create
      super do |success, failure|
        success.html do
          product = Product.find(resource.product_id)
          
          if product.rating.nil?
            product.update(rating: resource.rate)
          else
            new_rating = ((product.rating.to_f + resource.rate.to_f) / 2).round(1)
            product.update(rating: new_rating)
          end

          redirect_to admin_rating_path(resource) and return
        end

        failure.html do

        end
      end
    end
  end

  form do |f|
    f.inputs "Product Rating and Reviews" do
      f.input :product_id, as: :hidden, input_html: { value: f.object.product_id }
      f.input :admin_user_id, as: :hidden, input_html: { value: f.object.admin_user_id }
      f.input :order_id, as: :hidden, input_html: { value: f.object.order_id }
      f.input :rate
      f.input :comments, as: :text, input_html: { rows: 6, cols: 60 }
      f.input :photos, as: :file, input_html: { multiple: true, name: "rating[photos][]" }
    end
    f.actions
  end
end
