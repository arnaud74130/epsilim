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

class Charge < ActiveRecord::Base
  belongs_to :chantier
  belongs_to :type_charge
  belongs_to :fournisseur
  # before_save :update_total_fonct_hp?

  default_scope {order('paiement DESC')}

  def coupure(pdebut, pfin)

    if self.montant && pdebut && pfin && self.periode_debut && self.periode_fin
      if self.periode_fin > pfin
        delta = pfin.to_datetime - self.periode_debut.to_datetime
        duree =self.periode_fin.to_datetime - self.periode_debut.to_datetime
        p=delta.to_f/duree
        prix = self.montant * p
      else
        prix = self.montant
      end
    else
      0
    end
  end

  def cut_off(pdebut, pfin)
    if pdebut && pfin
      self.montant - self.coupure(pdebut, pfin)
    end
  end
  #-- exercice

  validates :montant, :presence => true
  # def update_total_fonct_hp?
  #   if self.chantier.type_chantier == 'fonctionnement'  || self.chantier.type_chantier=='hors_projet'
  #     ex2=sefl.chantier.exercice
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
