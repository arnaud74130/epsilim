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

class TypeFinancementsController < ApplicationController
  before_action :direction_required  
  before_action :set_exercice  
  before_action :set_type_financement, only: [:show, :edit, :update, :destroy]
  before_action :direction_required, only: [:edit, :update, :create, :destroy, :new]
  # GET /type_financements
  # GET /type_financements.json
  def index
  end

  # GET /type_financements/1
  # GET /type_financements/1.json
  def show
  end

  # GET /type_financements/new
  def new
    @type_financement = @exercice.type_financements.build
  end

  # GET /type_financements/1/edit
  def edit
  end

  # POST /type_financements
  # POST /type_financements.json
  def create
    @type_financement = @exercice.type_financements.new(type_financement_params)

    respond_to do |format|
      if @type_financement.save
        format.html { redirect_to [@exercice, @type_financement], notice: 'Type financement was successfully created.' }        
      else
        format.html { render action: 'new' }        
      end
    end
  end

  # PATCH/PUT /type_financements/1
  # PATCH/PUT /type_financements/1.json
  def update
    respond_to do |format|
      if @type_financement.update(type_financement_params)
        format.html { redirect_to [@exercice, @type_financement], notice: 'Type financement was successfully updated.' }        
      else
        format.html { render action: 'edit' }        
      end
    end
  end

  # DELETE /type_financements/1
  # DELETE /type_financements/1.json
  def destroy
    @type_financement.destroy
    respond_to do |format|
      format.html { redirect_to exercice_type_financements_url }      
    end
  end

  private
    def set_exercice
       @exercice=Exercice.find(params[:exercice_id])      
       @type_financements = @exercice.type_financements
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_type_financement
      @type_financement = @exercice.type_financements.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def type_financement_params
      params.require(:type_financement).permit(:exercice_id ,:nom, :couleur)
    end
end
