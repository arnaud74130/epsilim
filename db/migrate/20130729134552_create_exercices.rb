class CreateExercices < ActiveRecord::Migration
  def change
    create_table :exercices do |t|
      t.string :nom
      t.integer :code
      t.date :debut
      t.date :fin

      t.timestamps
    end
  end
end
