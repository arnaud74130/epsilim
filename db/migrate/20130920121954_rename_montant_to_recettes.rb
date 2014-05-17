class RenameMontantToRecettes < ActiveRecord::Migration
  def change
  		rename_column :recettes, :montant, :montant_investissement
  		rename_column :recettes, :periode_debut, :debut_investissement
  		rename_column :recettes, :periode_fin, :fin_investissement  			
  end
end
