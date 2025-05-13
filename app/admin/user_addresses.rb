ActiveAdmin.register UserAddress do

  permit_params :country, :state, :dist, :block, :town, :gali_no, :house_no, :user_id

  controller do
    def scoped_collection
      if current_admin_user.admin? 
        UserAddress.all
      else
        UserAddress.where(user_id: current_admin_user.id)
      end
    end
  end
  filter :user_id, as: :select, collection: -> {
    if current_admin_user.seller?
      AdminUser.where(user_type: 'user')
               .joins("INNER JOIN orders ON orders.user_id = admin_users.id")
               .where(orders: { seller_id: current_admin_user.id })
               .distinct
               .map { |user| ["#{user.first_name} #{user.last_name} (#{user.email})", user.id] }
    end
  }, label: "Users who ordered from you"
  
  form do |f|
     f.inputs "Address Details" do
      f.input :country, as: :select, selected: "India", collection: ['India'] 
      f.input :state, as: :select, collection: Rails.application.config.indian_states, selected: f.object.state || 'Andhra Pradesh', input_html: { id: 'state-select' }
      f.input :dist
      f.input :block
      f.input :town
      f.input :gali_no
      f.input :house_no
      f.input :user_id, as: :hidden, input_html: { value: current_admin_user.id }
    end
    f.actions
  end

  index do
    selectable_column
      column :country
      column :state
      column :dist
      column :block
      column :town
      column :gali_no
      column :house_no
      actions
  end

  show do 
    attributes_table do
      row :country
      row :state
      row :dist
      row :block
      row :town
      row :gali_no
      row :house_no 
    end
  end
end