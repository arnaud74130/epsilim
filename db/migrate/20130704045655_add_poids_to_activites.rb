class AddPoidsToActivites < ActiveRecord::Migration
  def change
    add_column :activites, :poids, :float
  end
end
