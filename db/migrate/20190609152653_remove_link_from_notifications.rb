class RemoveLinkFromNotifications < ActiveRecord::Migration[5.2]
  def change
    remove_column :notifications, :link
  end
end
