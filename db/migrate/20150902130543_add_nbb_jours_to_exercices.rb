class AddNbbJoursToExercices < ActiveRecord::Migration
  def change
    add_column :exercices, :nb_jours, :integer
  end
end
