class AddCoutReelToPersonnes < ActiveRecord::Migration
  def change
    add_column :personnes, :cout_reel, :decimal, :default => 500
  end
end
