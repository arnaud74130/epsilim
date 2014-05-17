class AddTypeChantierToChantiers < ActiveRecord::Migration
  def change
    add_column :chantiers, :type_chantier, :string, default: 'projet'
  end
end
