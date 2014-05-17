class RemoveTaxesToPersonnes < ActiveRecord::Migration
  def change
    remove_column :personnes, :taxe_fonctionnement, :decimal
    remove_column :personnes, :taxe_hors_projet, :decimal
  end
end
