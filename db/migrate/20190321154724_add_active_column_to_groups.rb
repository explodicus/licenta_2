class AddActiveColumnToGroups < ActiveRecord::Migration[5.2]
  def change
    change_table :groups do |t|
      t.boolean "active"
    end
  end
end
