class AddIndexesToChantierpersonne < ActiveRecord::Migration
  def change
  	    add_index :chantierpersonnes, :chantier_id
	    add_index :chantierpersonnes, :personne_id
  end
end
