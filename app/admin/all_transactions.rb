# frozen_string_literal: true
ActiveAdmin.register_page "AllTransactions" do
  content title: "All Transactions"do
      columns do 
                column do 
                  panel "Total Transaction", class: "scrollable-panel" do 
                  end
              end 

      column do 
      panel "Total seller", class: "scrollable-panel" do 
      sellers = AdminUser.where(user_type: ['seller'])
      
      table_for sellers do
        column "Name" do |user|
          puts "print transaction"
           puts user.transactions
          link_to "#{user.first_name} #{user.last_name}", admin_transaction_path(user)
        end
        column :email
      end
     end
    end 
   end
  end
end
