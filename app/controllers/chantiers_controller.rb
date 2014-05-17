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

class ChantiersController < FinancesController
  skip_before_action :set_chantier, only: [:index, :new, :create]
  skip_before_action :chantiers_au_reel, only: [:index, :new, :create]

  def index
    @chantiers = @exercice.chantiers
  end

  def cr
    index_charges
    index_recettes
  end
  
  def show
    @exercice.chantiers.find(params[:id])
  end

  # GET /chantiers/new
  def new

    @chantier = @exercice.chantiers.build
    @personnes = @exercice.personnes
    @type_charges = @exercice.type_charges
    @type_recettes = @exercice.type_recettes
    
  end

  # GET /chantiers/1/edit
  def edit
  end

  # POST /chantiers
  # POST /chantiers.json
  def create
    @chantier = @exercice.chantiers.new(chantier_params)
    add_personnes_tc_tr_to_chantier
    respond_to do |format|
      if @chantier.save
        format.html { redirect_to [@exercice, @chantier], notice: 'Chantier was successfully created.' }
      else
        format.html { render action: 'new' }
      end
    end
  end

  # PATCH/PUT /chantiers/1
  # PATCH/PUT /chantiers/1.json
  def update
    respond_to do |format|
      if @chantier.update(chantier_params)
        @chantier.personnes.delete_all
        @chantier.type_charges.delete_all
        @chantier.type_recettes.delete_all
        add_personnes_tc_tr_to_chantier
        format.html { redirect_to [@exercice, @chantier], notice: 'Chantier was successfully updated.' }
      else
        format.html { render action: 'edit' }
      end
    end
  end

  # DELETE /chantiers/1
  # DELETE /chantiers/1.json
  def destroy
    @chantier.destroy
    respond_to do |format|
      format.html { redirect_to exercice_chantiers_url }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_exercice
    @exercice=Exercice.find(params[:exercice_id])
  end
  def set_chantier

    @chantier = @exercice.chantiers.includes(:personnes, :type_charges, :type_recettes).find(params[:id])
    @personnes = @exercice.personnes
    @type_charges = @exercice.type_charges
    @type_recettes = @exercice.type_recettes

  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def chantier_params
    params.require(:chantier).permit(:exercice_id, :numero, :code, :libelle, :statut, :debut, :fin, :personne_ids, :type_charge_ids, :type_recette_ids, :prendre_taxes, :type_chantier)
  end

  def add_personnes_tc_tr_to_chantier
    if params[:chantier][:personne_ids].present?
      # liste=params[:chantier][:personne_ids]
      # liste.each_key do |key|
      #   Personne.find(liste[key]).each do |p|
      #     cp= Chantierpersonne.create(personne: p, annee: key.to_i)
      #     @chantier.chantierpersonnes << cp
      #   end
      # end
      selected_personnes = Personne.find(params[:chantier][:personne_ids])
      selected_personnes.each do |p|
        @chantier.personnes << p
      end
    end

    if params[:chantier][:type_charge_ids].present?
      @selected_type_charges = TypeCharge.find(params[:chantier][:type_charge_ids])
      @selected_type_charges.each do |tc|
        @chantier.type_charges << tc
      end
    end

    if params[:chantier][:type_recette_ids].present?
      @selected_type_recettes = TypeRecette.find(params[:chantier][:type_recette_ids])
      @selected_type_recettes.each do |tr|
        @chantier.type_recettes << tr
      end
    end


  end
end
