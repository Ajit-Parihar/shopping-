ActiveAdmin.register_page "Profile" do
  # menu false  
  
  content title: "My Profile" do
    panel "Admin Details" do
      attributes_table_for current_admin_user do
        row :first_name
        row :last_name
        row :email
        row :created_at
        row :user_type
      end

    div style: "margin-top: 20px;" do
     link_to "Logout", destroy_admin_user_session_path, method: :delete, class: "button"
    end
      div style: "margin-top: 20px;" do
        unless current_admin_user.admin?
          link_to "Edit", edit_admin_admin_user_path(current_admin_user), class: "button"
        end
      end
    end
  end
end
