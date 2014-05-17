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

class ExercicesController < ApplicationController
  before_action :direction_ro_required
  before_action :set_exercice, only: [:show, :edit, :update, :destroy, :cr, :suivi_personnel, :a_valider, :suivi_fonds]

  def a_valider
    @chantiers_a_valider=[]
    @exercice.chantiers.each do |chantier|
      @chantiers_a_valider << chantier if chantier.recettes.where(mode: 'a_valider').count > 0
    end
  end

  def suivi_fonds
    @fonds = @exercice.regroupement_recettes_fonds
  end

  def suivi_personnel
    @periode_debut, @periode_fin = extraction_periode
    @all_personnes ={}
    @exercice.personnes.each do |p|
      @all_personnes[p.id] = p.suivi(mois: @periode_debut.month, mois2: @periode_fin.month, annee: @periode_debut.year, annee2: @periode_fin.year)
      @all_personnes[p.id] = Hash[@all_personnes[p.id].sort_by {|k,v| Chantier.find_by_code(k).numero}.reverse]
    end
    
  end

  def cr
    @periode_debut, @periode_fin = extraction_periode
    @total_cr = @exercice.total_cr(@periode_debut.to_fr, @periode_fin.to_fr)
    @fonct_synthese=@exercice.synthese_fonctionnement(@periode_debut.to_fr, @periode_fin.to_fr)
    @hp_synthese=@exercice.synthese_hors_projet(@periode_debut.to_fr, @periode_fin.to_fr)

  end

  # GET /exercices
  # GET /exercices.json
  def index
    @exercices = Exercice.all
  end

  # GET /exercices/1
  # GET /exercices/1.json
  def show
  end

  # GET /exercices/new
  def new
    @exercice = Exercice.new
  end

  # GET /exercices/1/edit
  def edit
  end

  # POST /exercices
  # POST /exercices.json
  def create
    @exercice = Exercice.new(exercice_params)

    respond_to do |format|
      if @exercice.save
        format.html { redirect_to @exercice, notice: 'Exercice was successfully created.' }
        format.json { render action: 'show', status: :created, location: @exercice }
      else
        format.html { render action: 'new' }
        format.json { render json: @exercice.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /exercices/1
  # PATCH/PUT /exercices/1.json
  def update
    respond_to do |format|
      if @exercice.update(exercice_params)
        format.html { redirect_to @exercice, notice: 'Exercice was successfully updated.' }
        format.js
      else
        format.html { render action: 'edit' }
        format.js
      end
    end
  end

  # DELETE /exercices/1
  # DELETE /exercices/1.json
  def destroy
    @exercice.destroy
    respond_to do |format|
      format.html { redirect_to exercices_url }
      format.json { head :no_content }
    end
  end

  private

  def extraction_periode
    if params[:deb_periode]
      periode_debut = Date.parse params[:deb_periode].values.join("-")
    else
      periode_debut = @exercice.debut
    end
    if params[:fin_periode]
      periode_fin = Date.parse params[:fin_periode].values.join("-")
    else
      periode_fin = @exercice.fin
    end

    return periode_debut, periode_fin
  end
  # Use callbacks to share common setup or constraints between actions.
  def set_exercice
    @exercice = Exercice.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def exercice_params
    if params[:exercice][:contribution_fonct].present?
      params[:exercice][:contribution_fonct]=params[:exercice][:contribution_fonct].from_money
    end

    if params[:exercice][:contribution_hors_projet].present?
      params[:exercice][:contribution_hors_projet]=params[:exercice][:contribution_hors_projet].from_money
    end

    params.require(:exercice).permit(:nom, :code, :debut, :fin, :deb_periode, :fin_periode, :contribution_fonct, :contribution_hors_projet)
  end
end
