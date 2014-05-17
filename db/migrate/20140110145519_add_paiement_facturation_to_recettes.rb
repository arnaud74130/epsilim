class AddPaiementFacturationToRecettes < ActiveRecord::Migration
  def change
    add_column :recettes, :paiement, :date
    add_column :recettes, :facturation, :date
  end
end
