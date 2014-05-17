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

class TypeChargesController < ApplicationController
before_action :direction_required
  before_action :set_exercice
  before_action :set_type_charge, only: [:show, :edit, :update, :destroy]
  before_action :direction_required, only: [:edit, :update, :create, :destroy, :new]
  # GET /type_charges
  # GET /type_charges.json
  def index
    set_exercice
    @type_charges = @exercice.type_charges
  end

  # GET /type_charges/1
  # GET /type_charges/1.json
  def show
  end

  # GET /type_charges/new
  def new
    set_exercice
    @type_charge = @exercice.type_charges.build
  end

  # GET /type_charges/1/edit
  def edit
  end

  # POST /type_charges
  # POST /type_charges.json
  def create
    @type_charge = @exercice.type_charges.new(type_charge_params)

    respond_to do |format|
      if @type_charge.save
        format.html { redirect_to [@exercice, @type_charge], notice: 'Type charge was successfully created.' }        
      else
        format.html { render action: 'new' }      
      end
    end
  end

  # PATCH/PUT /type_charges/1
  # PATCH/PUT /type_charges/1.json
  def update
    respond_to do |format|
      if @type_charge.update(type_charge_params)
        format.html { redirect_to [@exercice, @type_charge], notice: 'Type charge was successfully updated.' }        
      else
        format.html { render action: 'edit' }        
      end
    end
  end

  # DELETE /type_charges/1
  # DELETE /type_charges/1.json
  def destroy
    @type_charge.destroy
    respond_to do |format|
      format.html { redirect_to exercice_type_charges_url }      
    end
  end

  private
   def set_exercice
       @exercice=Exercice.find(params[:exercice_id])      
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_type_charge
      set_exercice
      @type_charge = TypeCharge.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def type_charge_params
      params.require(:type_charge).permit(:exercice_id, :nom, :poids)
    end
end
