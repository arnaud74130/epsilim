class AddChargePersonnelJourToExercices < ActiveRecord::Migration
  def change
    add_column :exercices, :charge_personnel_jour, :boolean, default: true
  end
end
