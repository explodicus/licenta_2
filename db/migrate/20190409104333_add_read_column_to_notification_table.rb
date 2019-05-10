class AddReadColumnToNotificationTable < ActiveRecord::Migration[5.2]
  def change
    change_table :notifications do |t|
      t.boolean "read"
    end
  end
end
