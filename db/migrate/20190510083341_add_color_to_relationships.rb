class AddColorToRelationships < ActiveRecord::Migration[5.2]
  def change
    add_column :relationships, :color, :string
  end
end
