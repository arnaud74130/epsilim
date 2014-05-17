class ChangePrendreTaxesToChantiers < ActiveRecord::Migration
  def change
  	change_column_default :chantiers, :prendre_taxes, true
  end
end
