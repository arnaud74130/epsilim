class ChangeTarifsToRecettes < ActiveRecord::Migration
  def change
  	change_column_default :recettes, :montant, 0
  	change_column_default :recettes, :tarif_vente, 0
  	change_column_default :recettes, :nombre_jours, 0
 
  end
end
