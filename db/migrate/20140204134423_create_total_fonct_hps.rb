class CreateTotalFonctHps < ActiveRecord::Migration
  def change
    create_table :total_fonct_hps do |t|
      t.boolean :recalculer_fonct, default: true
      t.boolean :recalculer_hp, default: true
      t.boolean :recalculer_total_contrib_fonct, default: true
      t.boolean :recalculer_total_contrib_hp, default: true
      t.boolean :recalculer_total_charges_fonct, default: true
      t.boolean :recalculer_total_charges_hp, default: true
      t.decimal :charges_fonct, default: 0
      t.decimal :recettes_fonct, default: 0
      t.decimal :contribution_fonct, default: 0
      t.decimal :charges_hp, default: 0
      t.decimal :recettes_hp, default: 0
      t.decimal :contribution_hp, default: 0
      t.string :total_contrib_fonct, default: ""
      t.string :total_contrib_hp, default: ""
      t.string :total_charges_hp, default: ""
      t.string :total_charges_fonct, default: ""
      t.timestamps
    end
  end
end
