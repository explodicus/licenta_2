class AddMoreColumnsToUsers < ActiveRecord::Migration[5.2]
  def change
    change_table :users do |t|
      t.string "first_name"
      t.string "last_name"
      t.date "date_of_birth"
      t.string "phone_number"
      t.float "discount"
      t.string "preferred_language"
    end
  end
end
