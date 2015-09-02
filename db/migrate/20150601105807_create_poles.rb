class CreatePoles < ActiveRecord::Migration
  def change
    create_table :poles do |t|
      t.string :libelle

      t.timestamps
    end
  end
end
