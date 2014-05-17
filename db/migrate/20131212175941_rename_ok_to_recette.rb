class RenameOkToRecette < ActiveRecord::Migration
  def change
  	rename_column :recettes, :is_ok, :a_valider
  	change_column_default :recettes, :a_valider, false
  end
end
