class AddNotesColumnToGroupsTable < ActiveRecord::Migration[5.2]
  def change
    change_table :groups do |t|
      t.text "notes"
    end
  end
end
