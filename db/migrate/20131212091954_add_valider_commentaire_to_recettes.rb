class AddValiderCommentaireToRecettes < ActiveRecord::Migration
  def change
    add_column :recettes, :is_ok, :boolean
    add_column :recettes, :commentaire, :string
  end
end
