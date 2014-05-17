class AddPersonneIdToPersonnes < ActiveRecord::Migration
  def change
    add_column :personnes, :personne_id, :integer
  end
end
