class AddUidToActivites < ActiveRecord::Migration
  def change
    add_column :activites, :uid, :string
  end
end
