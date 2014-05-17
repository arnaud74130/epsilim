class CreateFournisseurs < ActiveRecord::Migration
  def change
    create_table :fournisseurs do |t|
      t.string :nom
      t.string :contact
      t.string :tel
      t.string :email

      t.timestamps
    end
  end
end
