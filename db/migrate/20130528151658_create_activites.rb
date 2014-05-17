class CreateActivites < ActiveRecord::Migration
  def change
    create_table :activites do |t|
      t.datetime :debut
      t.datetime :fin
      t.references :personne, index: true
      t.references :chantier, index: true

      t.timestamps
    end
  end
end
