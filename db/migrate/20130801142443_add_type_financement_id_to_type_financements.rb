class AddTypeFinancementIdToTypeFinancements < ActiveRecord::Migration
  def change
    add_column :type_financements, :type_financement_id, :integer
  end
end
