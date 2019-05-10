class AddInVacationToGroups < ActiveRecord::Migration[5.2]
  def change
    add_column :groups, :in_vacation, :boolean
  end
end
