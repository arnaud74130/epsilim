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

class FinancesController < ApplicationController
  before_action :set_exercice, :set_chantier
  before_action :chantiers_au_reel
  before_action :direction_required, only: [:new, :edit, :update, :create, :destroy]

  def chantiers_au_reel
    role_access_denied if @chantier.prendre_taxes==false && !(current_user.is_direction? || current_user.is_ro?)
  end

  def index_charges(retourner_les_charges=false)
    @periode_debut, @periode_fin = extraction_periode
    @total_charges_previ=@chantier.total_charges_previ(retourner_les_charges)
    @total_charges=@chantier.total_charges(@periode_debut.to_fr, @periode_fin.to_fr, retourner_les_charges)
    @les_tc = @total_charges.except(:total, :total_reel, :liste, :jours, 'PERSONNEL_REELLE', 'ACTIVITE_PERSONNEL').keys << @total_charges_previ.except(:total, :liste).keys   
    @les_tc = @les_tc.flatten.compact.uniq
    @les_tc = @les_tc.flatten.compact.uniq.sort_by {|elt| @exercice.type_charges.where(nom: elt).first.poids}    
  end

  def index_recettes(retourner_les_recettes=false)
    @periode_debut, @periode_fin = extraction_periode
    @total_recettes_previ=@chantier.total_recettes_previ(retourner_les_recettes)
    @total_recettes_a_valider=@chantier.total_recettes_a_valider(retourner_les_recettes)
    @total_recettes_facturees=@chantier.total_recettes_facturees(@periode_debut.to_fr, @periode_fin.to_fr, retourner_les_recettes)
    @les_tr = @total_recettes_facturees.except(:total, :liste, :ratio, :total_contribution).keys << @total_recettes_previ.except(:total, :a_valider, :liste).keys       
    #@les_tr = @les_tr.flatten.compact.uniq
    @les_tr = @les_tr.flatten.compact.uniq.sort_by {|elt| @exercice.type_recettes.where(nom: elt).first.poids}    
  end

  def set_exercice
    @exercice=Exercice.find(params[:exercice_id])
    @type_financements=@exercice.type_financements
  end

  def set_chantier
    @fournisseurs=@exercice.fournisseurs
    @chantier=@exercice.chantiers.find(params[:chantier_id])
    @type_charges=@chantier.type_charges
    @type_recettes = @chantier.type_recettes
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
end
