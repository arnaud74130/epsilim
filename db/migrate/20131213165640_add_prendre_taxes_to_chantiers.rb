class AddPrendreTaxesToChantiers < ActiveRecord::Migration
  def change
    add_column :chantiers, :prendre_taxes, :boolean, default: true
  end
end
