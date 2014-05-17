class AddFonctionnementToPersonnes < ActiveRecord::Migration
  def change
    add_column :personnes, :fonctionnement, :decimal, :default => 0
  end
end
