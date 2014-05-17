class AddPoidsToTypeRecettes < ActiveRecord::Migration
  def change
    add_column :type_recettes, :poids, :integer
  end
end
