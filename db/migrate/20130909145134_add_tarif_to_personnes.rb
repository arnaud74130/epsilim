class AddTarifToPersonnes < ActiveRecord::Migration
  def change
    add_column :personnes, :tarif, :float
  end
end
