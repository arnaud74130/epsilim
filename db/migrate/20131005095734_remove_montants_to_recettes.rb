class RemoveMontantsToRecettes < ActiveRecord::Migration
  def change
    remove_column :recettes, :montant_ss_traitance, :decimal
    remove_column :recettes, :montant_autres_recettes, :decimal
    remove_column :recettes, :montant_investissement, :decimal
  end
end
