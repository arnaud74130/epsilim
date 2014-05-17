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

class TypeRecettesController < ApplicationController
  before_action :direction_required  
  before_action :set_exercice
  before_action :set_type_recette, only: [:show, :edit, :update, :destroy]
  before_action :direction_required, only: [:edit, :update, :create, :destroy, :new]
  # GET /type_recettes
  # GET /type_recettes.json
  def index
    set_exercice
    @type_recettes = @exercice.type_recettes
  end

  # GET /type_recettes/1
  # GET /type_recettes/1.json
  def show
  end

  # GET /type_recettes/new
  def new
    @type_recette = TypeRecette.new
  end

  # GET /type_recettes/1/edit
  def edit
  end

  # POST /type_recettes
  # POST /type_recettes.json
  def create
    @type_recette = @exercice.type_recettes.new(type_recette_params)

    respond_to do |format|
      if @type_recette.save
        format.html { redirect_to [@exercice, @type_recette], notice: 'Type recette was successfully created.' }        
      else
        format.html { render action: 'new' }      
      end
    end
  end

  def update
    respond_to do |format|
      if @type_recette.update(type_recette_params)
        format.html { redirect_to [@exercice, @type_recette], notice: 'Type recette was successfully updated.' }        
      else
        format.html { render action: 'edit' }        
      end
    end
  end

  def destroy
    @type_recette.destroy
    respond_to do |format|
      format.html { redirect_to exercice_type_recettes_url }      
    end
  end

  private
   def set_exercice
       @exercice=Exercice.find(params[:exercice_id])      
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_type_recette
      set_exercice
      @type_recette = TypeRecette.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def type_recette_params
      params.require(:type_recette).permit(:exercice_id, :nom, :poids)
    end
end
