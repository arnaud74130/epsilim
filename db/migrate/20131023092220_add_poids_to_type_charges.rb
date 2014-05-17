class AddPoidsToTypeCharges < ActiveRecord::Migration
  def change
    add_column :type_charges, :poids, :integer
  end
end
