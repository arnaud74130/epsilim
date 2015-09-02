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

class PolesController < ApplicationController
  before_action :direction_required  
  before_action :set_exercice 
  
  before_action :set_pole, only: [:show, :edit, :update, :destroy]
  before_action :direction_required, only: [:edit, :update, :create, :destroy, :new]
  
  # GET /poles
  # GET /poles.json
  def index
    @poles = Pole.all
  end

  # GET /poles/1
  # GET /poles/1.json
  def show
  end

  # GET /poles/new
  def new
    @pole = @exercice.poles.build
  end

  # GET /poles/1/edit
  def edit
  end

  # POST /poles
  # POST /poles.json
  def create
    @pole = @exercice.poles.new(pole_params)

    respond_to do |format|
      if @pole.save
        format.html { redirect_to [@exercice, @pole], notice: 'Pole was successfully created.' }
        format.json { render action: 'show', status: :created, location: @pole }
      else
        format.html { render action: 'new' }
        format.json { render json: @pole.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /poles/1
  # PATCH/PUT /poles/1.json
  def update
    respond_to do |format|
      if @pole.update(pole_params)
        format.html { redirect_to [@exercice, @pole], notice: 'Pole was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @pole.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /poles/1
  # DELETE /poles/1.json
  def destroy
    @pole.destroy
    respond_to do |format|
      format.html { redirect_to exercice_poles_url }
      format.json { head :no_content }
    end
  end

  private
    def set_exercice
       @exercice=Exercice.find(params[:exercice_id])      
       @poles = @exercice.poles
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_pole
      @pole = @exercice.poles.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def pole_params
      params.require(:pole).permit(:exercice_id, :libelle)
    end
end
