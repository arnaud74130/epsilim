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

class ChargesController < FinancesController
  before_action :set_charge, only: [:show, :edit, :update, :destroy]

  # GET /charges
  # GET /charges.json
  def index
    index_charges(true)
  end

  # GET /charges/1
  # GET /charges/1.json
  def show
  end

  # GET /charges/new
  def new
    @charge = @chantier.charges.build

  end

  # GET /charges/1/edit
  def edit
  end

  # POST /charges
  # POST /charges.json
  def create
    @charge = @chantier.charges.new(charge_params)

    respond_to do |format|
      if @charge.save
        format.html { redirect_to [@exercice, @chantier, @charge], notice: 'Charge was successfully created.' }
      else
        format.html { render action: 'new' }
      end
    end
  end

  # PATCH/PUT /charges/1
  # PATCH/PUT /charges/1.json
  def update
    respond_to do |format|
      if @charge.update(charge_params)
        format.html { redirect_to [@exercice, @chantier, @charge], notice: 'Charge was successfully updated.' }
        # format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        # format.json { render json: @charge.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /charges/1
  # DELETE /charges/1.json
  def destroy
    @charge.destroy
    respond_to do |format|
      format.html { redirect_to exercice_chantier_charges_url }
      # format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_charge
    @charge = @chantier.charges.find(params[:id])
  end
  
  # Never trust parameters from the scary internet, only allow the white list through.
  def charge_params
    if params[:charge][:montant].present?
      params[:charge][:montant]=params[:charge][:montant].from_money
    end
    params.require(:charge).permit(:exercice_id,:chantier_id, :type_charge_id, :previ, :reception, :fournisseur_id, :nature, :paiement, :montant, :date_facturation, :periode_debut, :periode_fin)
  end
end
