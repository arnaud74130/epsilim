class AddPeriodeToRecettes < ActiveRecord::Migration
  def change
    add_column :recettes, :periode_debut, :date
    add_column :recettes, :periode_fin, :date
  end
end
