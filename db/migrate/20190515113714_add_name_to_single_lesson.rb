class AddNameToSingleLesson < ActiveRecord::Migration[5.2]
  def change
    add_column :single_lessons, :name, :string
  end
end
