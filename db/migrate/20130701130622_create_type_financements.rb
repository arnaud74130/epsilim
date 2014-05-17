class CreateTypeFinancements < ActiveRecord::Migration
  def change
    create_table :type_financements do |t|
      t.string :nom
      t.string :couleur

      t.timestamps
    end
  end
end
