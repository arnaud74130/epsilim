class RenameReceptionFromRecettes < ActiveRecord::Migration
  def change
  	rename_column :recettes, :reception, :emission
  end
end
