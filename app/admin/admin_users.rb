ActiveAdmin.register AdminUser do
  permit_params :email, :password, :password_confirmation, :user_type

  index do
    selectable_column
    id_column
    column :email
    column :user_type
  
  end

  filter :email


  form do |f|
    f.inputs do
      f.input :email
      f.input :password
      f.input :password_confirmation
      f.input :user_type, as: :radio,
      collection: [["seller", "seller"], ["user", "user"]],
      label: "User Type"
    end
    f.actions
  end

end
