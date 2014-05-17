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

class Recette < ActiveRecord::Base
  belongs_to :chantier
  belongs_to :type_recette
  belongs_to :type_financement
  # before_save :update_total_fonct_hp?

  #-- exercice

  validates :montant, :presence => true
  validates :type_financement, :presence => true
  validates :type_recette, :presence => true

  # def update_total_fonct_hp?
  #   if self.chantier.type_chantier == 'fonctionnement'  || self.chantier.type_chantier=='hors_projet'
  #     ex2=self.chantier.exercice
  #     t = TotalFonctHp.where(exercice: ex2).first_or_create(exercice: ex2)
  #     t.recalculer_fonct = true
  #     t.recalculer_hp = true
  #     t.recalculer_total_contrib_fonct = true
  #     t.recalculer_total_contrib_hp = true
  #     t.recalculer_total_charges_fonct = true
  #     t.recalculer_total_charges_hp = true
  #     t.save
  #   end
  # end
end
