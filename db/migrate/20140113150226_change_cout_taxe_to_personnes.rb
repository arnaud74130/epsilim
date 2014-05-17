class ChangeCoutTaxeToPersonnes < ActiveRecord::Migration
  def change
  	rename_column :personnes, :cout, :tarif_vente
  	rename_column :personnes, :fonctionnement, :taxe_fonctionnement
  	rename_column :personnes, :hors_projet, :taxe_hors_projet
  	change_column_default :personnes, :cout_reel, 0
  	change_column_default :personnes, :tarif_vente, 500
  	change_column_default :personnes, :taxe_fonctionnement, 0
  	change_column_default :personnes, :taxe_hors_projet, 0  	
  end
end
