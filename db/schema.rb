# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140210161727) do

  create_table "activites", force: true do |t|
    t.integer  "personne_id"
    t.integer  "chantier_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "jour"
    t.integer  "annee"
    t.string   "uid"
    t.float    "poids"
  end

  add_index "activites", ["chantier_id"], name: "index_activites_on_chantier_id"
  add_index "activites", ["personne_id"], name: "index_activites_on_personne_id"

  create_table "chantierpersonnes", force: true do |t|
    t.integer  "chantier_id"
    t.integer  "personne_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "chantierpersonnes", ["chantier_id"], name: "index_chantierpersonnes_on_chantier_id"
  add_index "chantierpersonnes", ["personne_id"], name: "index_chantierpersonnes_on_personne_id"

  create_table "chantiers", force: true do |t|
    t.integer  "numero"
    t.string   "code"
    t.string   "libelle"
    t.string   "statut"
    t.date     "debut"
    t.date     "fin"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "exercice_id"
    t.integer  "chantier_id"
    t.boolean  "prendre_taxes", default: true
    t.string   "type_chantier", default: "projet"
  end

  create_table "charges", force: true do |t|
    t.integer  "chantier_id"
    t.integer  "type_charge_id"
    t.boolean  "previ"
    t.date     "reception"
    t.integer  "fournisseur_id"
    t.string   "nature"
    t.date     "paiement"
    t.float    "montant"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "date_facturation"
    t.date     "periode_debut"
    t.date     "periode_fin"
  end

  add_index "charges", ["chantier_id"], name: "index_charges_on_chantier_id"
  add_index "charges", ["fournisseur_id"], name: "index_charges_on_fournisseur_id"
  add_index "charges", ["type_charge_id"], name: "index_charges_on_type_charge_id"

  create_table "exercices", force: true do |t|
    t.string   "nom"
    t.integer  "code"
    t.date     "debut"
    t.date     "fin"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "charge_personnel_jour",    default: true
    t.decimal  "contribution_fonct",       default: 0.0
    t.decimal  "contribution_hors_projet", default: 0.0
  end

  create_table "fournisseurs", force: true do |t|
    t.string   "nom"
    t.string   "contact"
    t.string   "tel"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "exercice_id"
    t.integer  "fournisseur_id"
  end

  create_table "personnes", force: true do |t|
    t.string   "nom"
    t.string   "prenom"
    t.string   "initiale"
    t.string   "mail"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "exercice_id"
    t.integer  "personne_id"
    t.float    "tarif_vente",        default: 500.0
    t.string   "encrypted_password"
    t.string   "salt"
    t.string   "username"
    t.string   "roles"
    t.decimal  "cout_reel",          default: 0.0
  end

  create_table "recettes", force: true do |t|
    t.integer  "chantier_id"
    t.integer  "type_financement_id"
    t.string   "nature"
    t.date     "emission"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "tarif_vente",         precision: 8, scale: 2, default: 0.0
    t.integer  "nombre_jours",                                default: 0
    t.date     "periode_debut"
    t.date     "periode_fin"
    t.integer  "type_recette_id"
    t.decimal  "montant",             precision: 8, scale: 2, default: 0.0
    t.string   "commentaire"
    t.string   "mode",                                        default: "facturee"
    t.date     "paiement"
    t.date     "facturation"
  end

  create_table "total_fonct_hps", force: true do |t|
    t.boolean  "recalculer_fonct",               default: true
    t.boolean  "recalculer_hp",                  default: true
    t.boolean  "recalculer_total_contrib_fonct", default: true
    t.boolean  "recalculer_total_contrib_hp",    default: true
    t.boolean  "recalculer_total_charges_fonct", default: true
    t.boolean  "recalculer_total_charges_hp",    default: true
    t.decimal  "charges_fonct",                  default: 0.0
    t.decimal  "recettes_fonct",                 default: 0.0
    t.decimal  "contribution_fonct",             default: 0.0
    t.decimal  "charges_hp",                     default: 0.0
    t.decimal  "recettes_hp",                    default: 0.0
    t.decimal  "contribution_hp",                default: 0.0
    t.string   "total_contrib_fonct",            default: ""
    t.string   "total_contrib_hp",               default: ""
    t.string   "total_charges_hp",               default: ""
    t.string   "total_charges_fonct",            default: ""
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "exercice_id"
  end

  create_table "type_charge_chantiers", force: true do |t|
    t.integer  "chantier_id"
    t.integer  "type_charge_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "type_charge_chantiers", ["chantier_id", "type_charge_id"], name: "index_type_charge_chantiers_on_chantier_id_and_type_charge_id"

  create_table "type_charges", force: true do |t|
    t.string   "nom"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "exercice_id"
    t.integer  "type_charge_id"
    t.integer  "poids"
  end

  create_table "type_financements", force: true do |t|
    t.string   "nom"
    t.string   "couleur"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "exercice_id"
    t.integer  "type_financement_id"
  end

  create_table "type_recette_chantiers", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "chantier_id"
    t.integer  "type_recette_id"
  end

  create_table "type_recettes", force: true do |t|
    t.string   "nom"
    t.integer  "exercice_id"
    t.integer  "type_recette_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "poids"
  end

end
