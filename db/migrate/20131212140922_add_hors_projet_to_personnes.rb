class AddHorsProjetToPersonnes < ActiveRecord::Migration
  def change
    add_column :personnes, :hors_projet, :decimal
  end
end
