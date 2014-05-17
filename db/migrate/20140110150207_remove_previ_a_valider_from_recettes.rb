class RemovePreviAValiderFromRecettes < ActiveRecord::Migration
  def change
    remove_column :recettes, :a_valider, :boolean
    remove_column :recettes, :previ, :boolean
  end
end
