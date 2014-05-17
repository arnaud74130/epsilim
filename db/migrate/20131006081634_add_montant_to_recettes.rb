class AddMontantToRecettes < ActiveRecord::Migration
  def change
    add_column :recettes, :montant, :decimal, :precision => 8, :scale => 2
  end
end
