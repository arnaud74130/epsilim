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

class FournisseursController < ApplicationController
  before_action :set_exercice
  before_action :set_fournisseur, only: [:show, :edit, :update, :destroy]
  before_action :direction_required, only: [:edit, :update, :create, :destroy, :new]
  # GET /fournisseurs
  # GET /fournisseurs.json
  def index
    @fournisseurs = @exercice.fournisseurs
  end

  # GET /fournisseurs/1
  # GET /fournisseurs/1.json
  def show
  end

  # GET /fournisseurs/new
  def new
    @fournisseur = @exercice.fournisseurs.build
  end

  # GET /fournisseurs/1/edit
  def edit
  end

  # POST /fournisseurs
  # POST /fournisseurs.json
  def create
    @fournisseur = @exercice.fournisseurs.new(fournisseur_params)

    respond_to do |format|
      if @fournisseur.save
        format.html { redirect_to [@exercice, @fournisseur], notice: 'Fournisseur was successfully created.' }        
      else
        format.html { render action: 'new' }        
      end
    end
  end

  # PATCH/PUT /fournisseurs/1
  # PATCH/PUT /fournisseurs/1.json
  def update
    respond_to do |format|
      if @fournisseur.update(fournisseur_params)
        format.html { redirect_to [@exercice, @fournisseur], notice: 'Fournisseur was successfully updated.' }        
      else
        format.html { render action: 'edit' }        
      end
    end
  end

  # DELETE /fournisseurs/1
  # DELETE /fournisseurs/1.json
  def destroy
    @fournisseur.destroy
    respond_to do |format|
      format.html { redirect_to exercice_fournisseurs_url }      
    end
  end

  private
    def set_exercice
      @exercice=Exercice.find(params[:exercice_id])      
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_fournisseur
      @fournisseur = Fournisseur.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def fournisseur_params
      params.require(:fournisseur).permit(:nom, :contact, :tel, :email)
    end
end
