class AddPeriodeToCharges < ActiveRecord::Migration
  def change
    add_column :charges, :date_facturation, :date
    add_column :charges, :periode_debut, :date
    add_column :charges, :periode_fin, :date
    add_column :charges, :periode, :boolean
  end
end
