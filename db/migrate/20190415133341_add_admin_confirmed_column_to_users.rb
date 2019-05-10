class AddAdminConfirmedColumnToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :admin_confirmed, :boolean
  end
end
