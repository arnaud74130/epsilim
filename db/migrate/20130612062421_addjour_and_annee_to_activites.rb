class AddjourAndAnneeToActivites < ActiveRecord::Migration
  def change
  	add_column :activites, :jour, :integer
  	add_column :activites, :annee, :integer
  end
end
