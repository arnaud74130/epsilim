class RemoveAnneeToChantierpersonnes < ActiveRecord::Migration
  def change
    remove_column :chantierpersonnes, :annee, :integer
  end
end
