class AddChantierIdToChantiers < ActiveRecord::Migration
  def change
    add_column :chantiers, :chantier_id, :integer
  end
end
