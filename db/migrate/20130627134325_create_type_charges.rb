class CreateTypeCharges < ActiveRecord::Migration
  def change
    create_table :type_charges do |t|
      t.string :type

      t.timestamps
    end
  end
end
