class AddTypesRecettesToRecettes < ActiveRecord::Migration
  def change
    add_column :recettes, :montant_ss_traitance, :decimal
    add_column :recettes, :debut_ss_traitance, :date
    add_column :recettes, :fin_ss_traitance, :date
    add_column :recettes, :montant_autres_recettes, :decimal
    add_column :recettes, :debut_autres_recettes, :date
    add_column :recettes, :fin_autres_recettes, :date
  end
end
