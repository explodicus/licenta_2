class RenameTimetablesToLessons < ActiveRecord::Migration[5.2]
  def change
    rename_table :timetables, :lessons
  end
end
