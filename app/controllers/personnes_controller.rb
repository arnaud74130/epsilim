#     EPSILIM - Suivi Financier
#     Copyright (C) 2014  Arnaud GARCIA - GCS EPSILIM
#                         
#     This program is free software: you can redistribute it and/or modify
#     it under the terms of the GNU General Public License as published by
#     the Free Software Foundation, either version 3 of the License, or
#     (at your option) any later version.

#     This program is distributed in the hope that it will be useful,
#     but WITHOUT ANY WARRANTY; without even the implied warranty of
#     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#     GNU General Public License for more details.

#     You should have received a copy of the GNU General Public License
#     along with this program.  If not, see <http://www.gnu.org/licenses/>.

class PersonnesController < ApplicationController  
  before_action :set_exercice
  before_action :cp_id, only: [:activite, :activite_supp, :activite_create, :activite_destroy]
  before_action :set_personne, only: [:show, :edit, :update, :destroy, :activite, :activite_supp, :activite_create, :activite_destroy, :activites, :suivi]
  before_action :direction_required, only: [:edit, :update, :create, :destroy, :new]
  def index
    @personnes = current_exercice.personnes
    respond_to do |format|
      
      format.html
      format.xls # { send_data @products.to_csv(col_sep: "\t") }
    end
  end

  def show

  end

  def new
    @personne = current_exercice.personnes.build
    @personne.roles=:cp
  end

  def edit
    
  end

  def create
    @personne = current_exercice.personnes.new(personne_params)

    respond_to do |format|
      if @personne.save
        format.html { redirect_to [current_exercice, @personne], notice: 'Personne was successfully created.' }
      else
        format.html { render action: 'new' }
      end
    end
  end

  # PATCH/PUT /personnes/1
  # PATCH/PUT /personnes/1.json
  def update
    respond_to do |format|
      if @personne.update(personne_params)
        format.html { redirect_to [current_exercice, @personne], notice: 'Personne was successfully updated.' }
      else
        format.html { render action: 'edit' }
      end
    end
  end

  # DELETE /personnes/1
  # DELETE /personnes/1.json
  def destroy
    @personne.destroy
    respond_to do |format|
      format.html { redirect_to exercice_personnes_url }
    end
  end

  # -- Gestion de l'activité --

  def activite
    # render layout: 'activite'

  end

  def activite_create
    chantier_id=params[:select_chantier]
    annee=params[:annee]
    jour=params[:jour]
    @uid=params[:uid]

    activite=Activite.find_by_uid(@uid)
    @remove_select = 0 # ne pas supprimer l'enregistrement
    if (activite)
      activite.update(chantier_id: chantier_id)
    else
      @nbre_activites=@personne.activites_jour_annee(jour, annee).size
      if @nbre_activites < 4
        @personne.activites.create(chantier_id: chantier_id, annee: annee, jour: jour, uid: @uid)
      else
        @remove_select = 1
      end
    end
    respond_to do |format|
      format.js
    end
  end

  def activite_supp
    @jour = params[:jour]
    @annee = params[:annee]
    @nbre_activites=@personne.activites_jour_annee(@jour, @annee).size
    respond_to do |format|
      format.js
    end
  end

  def activite_destroy
    @uid=params[:uid]
    activite=Activite.find_by_uid(@uid)
    j=activite.jour
    total=@personne.activites.where(jour: j).count-1
    @personne.activites.where(jour: j).update_all(poids: 1.0/total)
    activite.destroy

    respond_to do |format|
      format.js
    end
  end

  def suivi
    @suivi_activite=@personne.suivi(params)
    @chantier=Chantier.find(params[:chantier_id]) if params[:chantier_id]
    @mois=params[:mois]
    @mois2=params[:mois2]
    @annee=params[:annee]
    @annee2=params[:annee2]
  end
 def set_exercice
    @exercice=Exercice.find(params[:exercice_id])
  end
  # Use callbacks to share common setup or constraints between actions.
  def set_personne
    @personne = @exercice.personnes.includes(:chantiers).find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def personne_params
    if params[:personne][:cout].present?
      params[:personne][:cout]=params[:personne][:cout].from_money
    end
    
    if params[:personne][:cout_reel].present?
      params[:personne][:cout_reel]=params[:personne][:cout_reel].from_money
    end

    if params[:personne][:fonctionnement].present?
      params[:personne][:fonctionnement]=params[:personne][:fonctionnement].from_money
    end

    if params[:personne][:hors_projet].present?
      params[:personne][:hors_projet]=params[:personne][:hors_projet].from_money
    end
    
    params.require(:personne).permit(:exercice_id, :nom, :prenom, :initiale, :mail, :tarif_vente, :cout_reel,:password, :password_confirmation, :username, :roles)
  end
end