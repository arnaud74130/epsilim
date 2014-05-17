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

class RecettesController < FinancesController 
  before_action :set_recette, only: [:show, :edit, :update, :destroy]

  # GET /recettes
  # GET /recettes.json
  def index
    index_recettes(true)
  end

  # GET /recettes/1
  # GET /recettes/1.json
  def show
  end

  # GET /recettes/new
  def new
    @recette = @chantier.recettes.build
  end

  # GET /recettes/1/edit
  def edit
  end

  # POST /recettes
  # POST /recettes.json
  def create
    @recette = @chantier.recettes.new(recette_params)

    respond_to do |format|
      if @recette.save
        format.html { redirect_to [@exercice, @chantier, @recette], notice: 'Recette was successfully created.' }
        # format.json { render action: 'show', status: :created, location: @recette }
      else
        format.html { render action: 'new' }
        # format.json { render json: @recette.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /recettes/1
  # PATCH/PUT /recettes/1.json
  def update
    respond_to do |format|
      if @recette.update(recette_params)
        format.html { redirect_to [@exercice, @chantier, @recette], notice: 'Recette was successfully updated.' }
        # format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        # format.json { render json: @recette.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /recettes/1
  # DELETE /recettes/1.json
  def destroy
    @recette.destroy
    respond_to do |format|
      format.html { redirect_to exercice_chantier_recettes_url }

    end
  end

  private
  
  # Use callbacks to share common setup or constraints between actions.
  def set_recette
    @recette = @chantier.recettes.find(params[:id])

  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def recette_params
    if params[:recette][:montant].present?
      params[:recette][:montant]=params[:recette][:montant].from_money
    end

    if params[:recette][:tarif_vente].present?
      params[:recette][:tarif_vente]=params[:recette][:tarif_vente].from_money
    end

    params.require(:recette).permit(:exercice_id,:chantier_id, :type_financement_id, :type_recette_id, :nature, :emission, :montant, :facturation, :tarif_vente, :nombre_jours, :montant, :periode_debut, :periode_fin, :commentaire, :mode, :paiement)
  end
end