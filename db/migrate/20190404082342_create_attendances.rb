class CreateAttendances < ActiveRecord::Migration[5.2]
  def change
    create_table :attendances do |t|
      t.references :user, foreign_key: true
      t.references :group, foreign_key: true
      t.datetime :time

      t.timestamps
    end
  end
end
