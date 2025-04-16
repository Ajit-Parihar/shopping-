ActiveAdmin.register UserAddress do
  permit_params :country, :state, :dist, :block, :town, :gali_no, :house_no, :user_id

  form do |f|
    f.inputs "Address Details" do
      f.input :country, as: :country
      f.input :state
      f.input :dist
      f.input :block
      f.input :town
      f.input :gali_no
      f.input :house_no
      f.input :user_id, as: :hidden, input_html: { value: current_admin_user.id }
      f.input :product_id, as: :hidden, input_html: { value: params[:product_id] }
    end
    f.actions
  end

  controller do 
    def create
      super do |success, _failure|
        product_id = params[:user_address][:product_id]
        success.html { redirect_to admin_buy_path(product_id: product_id), notice: "Address saved successfully." and return }
      end
    end
  end
end
