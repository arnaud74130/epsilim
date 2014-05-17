class AddAnneeToChantierpersonnes < ActiveRecord::Migration
  def change
    add_column :chantierpersonnes, :annee, :integer, :default => 2012
  end
end
