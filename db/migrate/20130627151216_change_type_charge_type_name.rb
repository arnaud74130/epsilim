class ChangeTypeChargeTypeName < ActiveRecord::Migration
  def change
  	rename_column :type_charges, :type, :nom
  end
end
