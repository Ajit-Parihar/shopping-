ActiveAdmin.register AdminUser do
  permit_params :first_name, :last_name, :email, :password, :password_confirmation, :user_type

  index do
    selectable_column
    id_column
    
    column "Name" do |user|
      link_to "#{user.first_name} #{user.last_name}", admin_admin_user_path(user)
    end

    column :email
    column :user_type
  end
  filter :email
  
  form do |f|
    f.inputs "Admin User Details" do
      f.input :first_name
      f.input :last_name
      f.input :email
      f.input :password
      f.input :password_confirmation
      f.input :user_type,
              as: :radio,
              collection: [["Seller", "seller"], ["User", "user"]],
              label: "User Type"
    end
    f.actions
  end

  show do
    attributes_table do
      row :first_name
      row :last_name
      row :email
      row :user_type
    end
  end
end
