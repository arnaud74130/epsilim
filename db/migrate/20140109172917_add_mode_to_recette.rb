class AddModeToRecette < ActiveRecord::Migration
  def change
    add_column :recettes, :mode, :string, default: "facturee"
  end
end
