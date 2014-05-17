class AddFournisseurIdToFournisseurs < ActiveRecord::Migration
  def change
    add_column :fournisseurs, :fournisseur_id, :integer
  end
end
