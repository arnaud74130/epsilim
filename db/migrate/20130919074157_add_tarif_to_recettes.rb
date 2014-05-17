class AddTarifToRecettes < ActiveRecord::Migration
  def change
    add_column :recettes, :tarif_vente, :decimal, :precision => 8, :scale => 2
    add_column :recettes, :nombre_jours, :integer
    add_column :recettes, :periode_debut, :date
    add_column :recettes, :periode_fin, :date
  end
end
