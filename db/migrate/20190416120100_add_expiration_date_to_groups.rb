class AddExpirationDateToGroups < ActiveRecord::Migration[5.2]
  def change
    add_column :groups, :expiration_date, :date
  end
end
