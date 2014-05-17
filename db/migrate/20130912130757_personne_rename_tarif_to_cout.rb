class PersonneRenameTarifToCout < ActiveRecord::Migration
  def change
  	rename_column :personnes, :tarif, :cout
  end
end
