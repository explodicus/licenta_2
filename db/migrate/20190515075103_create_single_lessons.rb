class CreateSingleLessons < ActiveRecord::Migration[5.2]
  def change
    create_table :single_lessons do |t|
      t.references :group, foreign_key: true
      t.datetime :start_date_time
      t.datetime :end_date_time

      t.timestamps
    end
  end
end
