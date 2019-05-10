class CreateTimetables < ActiveRecord::Migration[5.2]
  def change
    create_table :timetables do |t|
      t.references :group, foreign_key: true
      t.integer :week_day
      t.time :start_time
      t.time :end_time

      t.timestamps
    end
  end
end
