ActiveAdmin.register AdminUser do
  permit_params :first_name, :last_name, :email, :password, :password_confirmation, :user_type

  menu if: proc { current_admin_user.admin? }

  # Batch action to send welcome email
  batch_action :send_welcome_email do |selected_ids|
    AdminUser.find(selected_ids).each do |admin_user|
      AdminUserMailer.welcome_email(admin_user).deliver
    end
    redirect_to collection_path, notice: "Welcome email sent successfully"
  end

  controller do
    def scoped_collection
      AdminUser.with_deleted.where(user_type: ['seller', 'user'])
    end
  end

  filter :first_name_or_last_name_cont, label: "Name"
  filter :user_type, as: :select, collection: -> { AdminUser.distinct.pluck(:user_type) }

  index do
    selectable_column
    id_column

    column "Name" do |user|
      link_to "#{user.first_name} #{user.last_name}", admin_admin_user_path(user)
    end

    column :email
    column :user_type

    actions defaults: false do |user|
      item "View", resource_path(user), class: "button buy-button"
      item "Edit", edit_resource_path(user), class: "button buy-button"

      unless user.deleted_at.present?
        item "Delete", resource_path(user),
             method: :delete,
             data: { confirm: "Are you sure?" },
             class: "button buy-button"
      end

      if user.deleted_at.present?
        item "Restore", restore_admin_admin_user_path(user),
             method: :put,
             data: { confirm: "Are you sure you want to restore this user?" },
             class: "button buy-button"
      end
    end
  end

  form do |f|
    f.inputs "Admin User Details" do
      f.input :first_name
      f.input :last_name
      f.input :email

      if f.object.new_record?
        f.input :password
        f.input :password_confirmation
      end

      if current_admin_user.admin?
        f.input :user_type,
                as: :radio,
                collection: [["Seller", "seller"], ["User", "user"]],
                label: "User Type"
      end
    end

    f.actions do 
      if current_admin_user.admin?
        f.action :submit, label: "Create Rating"
        f.cancel_link(admin_admin_users_path)  
      else
        f.action :submit, label: "Create Rating"
        f.cancel_link(admin_profile_path)  
      end
    end
  end

  show do
    attributes_table do
      row :first_name
      row :last_name
      row :email
      row :user_type
    end
  end

  member_action :restore, method: :put do
    resource.restore_with_dependents
    redirect_to admin_admin_users_path, notice: "User restored successfully!"
  end
end
