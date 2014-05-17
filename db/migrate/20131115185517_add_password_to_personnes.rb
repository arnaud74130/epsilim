class AddPasswordToPersonnes < ActiveRecord::Migration
  def change
    add_column :personnes, :encrypted_password, :string
    add_column :personnes, :salt, :string
    add_column :personnes, :username, :string
    add_column :personnes, :roles, :string
  end
end
