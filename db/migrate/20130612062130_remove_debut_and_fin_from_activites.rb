class RemoveDebutAndFinFromActivites < ActiveRecord::Migration
  def change
    remove_column :activites, :debut, :datetime
    remove_column :activites, :fin, :datetime
  end
end
