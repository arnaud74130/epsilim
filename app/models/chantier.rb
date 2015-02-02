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

class Chantier < ActiveRecord::Base
  default_scope {order('numero ASC')}
  before_save :check_prendre_taxes
  #-- exercice
  belongs_to :exercice

  # -- personnes
  has_many :chantierpersonnes
  has_many :personnes, through: :chantierpersonnes , dependent: :destroy

  # -- activités
  has_many :activites, dependent: :destroy

  # -- charges
  has_many :type_charge_chantiers
  has_many :type_charges, through: :type_charge_chantiers

  has_many :charges

  #-- recettes
  has_many :type_recette_chantiers
  has_many :type_recettes, through: :type_recette_chantiers

  has_many :recettes

  def type_charge_personnel
    self.type_charges.where(nom: 'PERSONNEL').first
  end


  #--- CHARGES ---
  def total_charges(debut=nil, fin=nil,retourner_les_charges=false)

    debut ||= self.exercice.debut.to_fr
    fin ||= self.exercice.fin.to_fr
    periode_debut = Date.from_fr_string(debut)
    periode_fin = Date.from_fr_string(fin)
    paquet={}
    paquet[:total] = 0
    unless self.type_chantier=='conges'
      chs=charges.where(previ: false).where('periode_debut >= ?', periode_debut).where('periode_debut <= ?', periode_fin)
      paquet = chs.inject({total: 0.0}) do |sum, charge|
        if charge.periode_fin > periode_fin
          delta = periode_fin.to_datetime - charge.periode_debut.to_datetime
          duree =charge.periode_fin.to_datetime - charge.periode_debut.to_datetime
          p=delta.to_f/duree
          prix = charge.montant * p
        else
          prix = charge.montant
        end
        sum[:total] = sum[:total] + prix.to_f

        tr=TypeCharge.find(charge.type_charge).nom
        sum[tr] ||= 0
        sum[tr]=sum[tr] + prix.to_f

        sum
      end
    end
    

    # Ajout des charges de PERSONNEL liées à l'activité.

    paquet['PERSONNEL'] ||=0
    # on régularise car on ajoute les charges manuelles de personnel dans la rubrique FINANCEUR ou REELLE
    paquet[:total] = paquet[:total] - paquet['PERSONNEL']
    paquet[:total_reel] = paquet[:total]


    paquet['PERSONNEL_FINANCEUR'] =  paquet['PERSONNEL']
    paquet['PERSONNEL_REELLE']= paquet['PERSONNEL']
    paquet['PERSONNEL_MANUELLE']= paquet['PERSONNEL']
    paquet['PERSONNEL'] = 0 # cela sert uniquement d'indicateur dans la synthese des charges...

     paquet['ACTIVITE_PERSONNEL'] = {}
    activite_consommees=self.jours_consommes(debut,fin)
    paquet[:jours]= activite_consommees[:total]
    unless self.type_chantier=='conges'
      activite_consommees.except(:total).each do |initiale, jours|

        p = self.exercice.personnes.where(initiale: initiale).first
        paquet['PERSONNEL_FINANCEUR'] = paquet['PERSONNEL_FINANCEUR'] + jours*p.tarif_vente.to_f
        paquet['ACTIVITE_PERSONNEL'].merge!({initiale => jours})
        paquet['PERSONNEL_REELLE'] = paquet['PERSONNEL_REELLE'] + jours*p.cout_reel.to_f
        if self.prendre_taxes
          paquet['PERSONNEL_REELLE'] = paquet['PERSONNEL_REELLE'] + jours*(self.exercice.contribution_fonct + self.exercice.contribution_hors_projet).to_f
        end
      end

      paquet[:total]=paquet[:total] + paquet['PERSONNEL_FINANCEUR']
      paquet[:total_reel]=paquet[:total_reel] + paquet['PERSONNEL_REELLE']
    end
    if retourner_les_charges
      chs ||= []
      paquet[:liste] = chs
    end
    paquet
  end

  def total_charges_previ(retourner_les_charges=false)
    chs=charges.where(previ: true)
    paquet = chs.inject({total: 0.0}) do |sum, charge|
      sum[:total] = sum[:total] + charge.montant.to_f
      tc=TypeCharge.find(charge.type_charge).nom
      sum[tc] ||= 0
      sum[tc]=sum[tc]+charge.montant.to_f
      sum
    end

    paquet[:liste] = chs if retourner_les_charges
    paquet
  end

  #--- RECETTES ---

  def total_recettes_previ(retourner_les_recettes=false)
    liste_r = self.recettes.where('mode = ? OR mode = ?', 'previ','a_valider')
    paquet = liste_r.inject({total: 0.0, a_valider: 0.0}) do |sum,recette|
      sum[:total] = sum[:total] + recette.montant.to_f
      sum[:a_valider] = sum[:a_valider] + recette.montant.to_f if recette.mode == 'a_valider'
      tr=TypeRecette.find(recette.type_recette).nom
      sum[tr] ||= 0
      sum[tr]=sum[tr]+recette.montant.to_f
      sum
    end
    paquet[:liste] = liste_r if retourner_les_recettes
    paquet
  end

  def total_recettes_a_valider(retourner_les_recettes=false)
    liste_r = self.recettes.where(mode: 'a_valider')
    paquet = liste_r.inject({total: 0.0}) do |sum,recette|
      sum[:total] = sum[:total] + recette.montant.to_f
      tr=TypeRecette.find(recette.type_recette).nom
      sum[tr] ||= 0
      sum[tr]=sum[tr]+recette.montant.to_f
      sum
    end
    paquet[:liste] = liste_r if retourner_les_recettes
    paquet
  end

  #FIXME appel la fonction update_recettes_contribution qui ne prend pas les dates !
  def total_recettes_facturees(debut=nil, fin=nil, retourner_les_recettes=false)
    debut ||= self.exercice.debut.to_fr
    fin ||= self.exercice.fin.to_fr
    periode_debut = Date.from_fr_string(debut)
    periode_fin = Date.from_fr_string(fin)

    liste_r = self.recettes.where(mode: 'facturee').where('periode_debut >= ?', periode_debut).where('periode_debut <= ?', periode_fin)
    paquet = liste_r.inject({total: 0.0}) do |sum, recette|
      if recette.periode_fin > periode_fin
        delta = periode_fin.to_datetime - recette.periode_debut.to_datetime
        duree =recette.periode_fin.to_datetime - recette.periode_debut.to_datetime
        p=delta.to_f/duree
        prix = recette.montant * p
      else
        prix = recette.montant
      end
      sum[:total] = sum[:total] + prix.to_f

      tr=TypeRecette.find(recette.type_recette).nom
      sum[tr] ||= 0
      sum[tr]=sum[tr] + prix.to_f

      sum
    end
    paquet[:liste] = liste_r if retourner_les_recettes

    if self.type_chantier=='fonctionnement' 
      paquet=update_recettes_contribution(paquet, "fonctionnement")
      paquet[:total] = paquet[:total] + paquet["FONCTIONNEMENT"]
      tr_fonct = self.exercice.type_recettes.where(nom: 'FONCTIONNEMENT').first
      paquet[:liste] << Recette.new(type_recette: tr_fonct, montant: paquet["FONCTIONNEMENT"], nature: "Contribution au fonctionnement") if retourner_les_recettes
    end

    if self.type_chantier=='hors_projet'
      paquet=update_recettes_contribution(paquet, "hors_projet")
      paquet[:total] = paquet[:total] + paquet["HORS_PROJET"]
      tr_hp = self.exercice.type_recettes.where(nom: 'HORS_PROJET').first
      paquet[:liste] << Recette.new(type_recette: tr_hp, montant: paquet["HORS_PROJET"], nature: "Contribution au hors-projet") if retourner_les_recettes
    end

    paquet
  end

 

  def jours_consommes(debut=nil, fin=nil)
    debut ||= self.exercice.debut.to_fr
    fin ||= self.exercice.fin.to_fr
    yday1, annee1, yday2, annee2 = Date.periode_string_to_ydays_years(debut, fin)
    if (annee2!=annee1)
      errors.add(:exercice, "Les calculs sont actuellement sur une seule année.")
      return nil
    end
    paquet = self.activites.where(annee: annee1, jour: [yday1..yday2]).inject({total: 0}) do |sum, activite|
      sum[:total]=sum[:total]+activite.poids
      sum[Personne.find(activite.personne).initiale] ||=0
      sum[Personne.find(activite.personne).initiale] =  sum[Personne.find(activite.personne).initiale] + activite.poids
      sum
    end
    paquet
  end
  
  private
   
   #FIXME doit intégrer la notion de période
   def update_recettes_contribution(paquet, nom)
    chantiers_projets = self.exercice.chantiers.where(type_chantier: 'projet')
    contrib = self.exercice.total_contribution(nom)
    
    # -- Etat des charges des chantiers de fonctionnement
    
    etat_contrib=self.exercice.total_charges_chantiers_hp_fonct(nom)
    
    # on affecte au prorata des charges la part des contributions
    ratio = etat_contrib[self.code] / etat_contrib[:total]

    paquet["#{nom.upcase}"] = contrib[:total] * ratio   
    paquet[:total_contribution] = contrib[:total]
    paquet[:ratio] = ratio
    paquet

  end
  def check_prendre_taxes
    if self.type_chantier=='projet'
      self.prendre_taxes = true
    end
    if self.type_chantier=='mission'
      self.prendre_taxes = false
    end
    if self.type_chantier=='fonctionnement'
      self.prendre_taxes = false
    end
    if self.type_chantier=='hors_projet'
      self.prendre_taxes = false
    end
    return true
  end
end
