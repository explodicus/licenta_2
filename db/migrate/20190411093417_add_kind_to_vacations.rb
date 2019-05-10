class AddKindToVacations < ActiveRecord::Migration[5.2]
  def change
    add_column :vacations, :kind, :string
  end
end
