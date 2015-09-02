class AddPoleIdToChantier < ActiveRecord::Migration
  def change
    add_column :chantiers, :pole_id, :integer
  end
end
