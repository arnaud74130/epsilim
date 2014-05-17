class RemoveSomeDatesFromRecettes < ActiveRecord::Migration
  def change
    remove_column :recettes, :debut_investissement, :date
    remove_column :recettes, :fin_investissement, :date
    remove_column :recettes, :debut_ss_traitance, :date
    remove_column :recettes, :fin_ss_traitance, :date
    remove_column :recettes, :debut_autres_recettes, :date
    remove_column :recettes, :fin_autres_recettes, :date
  end
end
