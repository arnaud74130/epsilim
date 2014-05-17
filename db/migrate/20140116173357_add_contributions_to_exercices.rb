class AddContributionsToExercices < ActiveRecord::Migration
  def change
    add_column :exercices, :contribution_fonct, :decimal, default: 0.0
    add_column :exercices, :contribution_hors_projet, :decimal, default: 0.0
    remove_column :exercices, :charges_personnel_jours, :boolean
  end
end
