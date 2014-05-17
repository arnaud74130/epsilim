class CreateChantierpersonnes < ActiveRecord::Migration
  def change
    create_table :chantierpersonnes do |t|
      t.integer :chantier_id
      t.integer :personne_id

      t.timestamps
    end
  end
end
