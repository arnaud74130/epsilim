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

class Exercice < ActiveRecord::Base
  has_many :chantiers
  has_many :personnes
  has_many :type_charges
  has_many :type_recettes
  has_many :type_financements
  has_many :fournisseurs
  has_one :total_fonct_hp

  def regroupement_recettes_fonds
    fonds = {}
    self.chantiers.each do |chantier|
      chantier.recettes.each do |recette|
        tmp_fonds = recette.nature.scan(/\$(.*?)\$/).flatten
        if tmp_fonds.size > 0
          tmp_fonds = tmp_fonds.join("-").gsub("$","")
          fonds[tmp_fonds] ||= {}
          fonds[tmp_fonds][:total_previ] ||= 0
          fonds[tmp_fonds][:total_facture] ||= 0
          fonds[tmp_fonds][:total_a_valider] ||= 0
          fonds[tmp_fonds][:chantiers] ||= []
          if recette.mode =="facturee"
            fonds[tmp_fonds][:total_facture] = fonds[tmp_fonds][:total_facture] + recette.montant.to_f
          end
          if recette.mode =="previ"
            fonds[tmp_fonds][:total_previ] = fonds[tmp_fonds][:total_previ] + recette.montant.to_f
          end
          if recette.mode =="a_valider"
            fonds[tmp_fonds][:total_a_valider] = fonds[tmp_fonds][:total_a_valider] + recette.montant.to_f
          end
          fonds[tmp_fonds][:chantiers] << recette.chantier.code
          fonds[tmp_fonds][:chantiers] = fonds[tmp_fonds][:chantiers].uniq
        end
      end
    end
    #Hash[fonds.sort_by {|k,v| v[:total]}.reverse]
    fonds
  end
  # les totaux de chaque rubrique et le details des projets hors fonctionnement et hors projet 
  # disponiblent avec les fonctions synthese_fonctionnement et hors_projet
  # {:total_recettes_previ=>7750.0, :total_recettes_a_valider=>6750.0, :total_charges_previ=>22543.0, :total_recettes_facturees=>1500.0, :total_charges=>20750.0, :total_charges_reelles=>15845.7375,
  # "DMP1"=>{:total_previ=>-14793.0, :recettes_previ=>7750.0, :recettes_a_valider=>6750.0, :charges_previ=>22543.0, :recettes_facturees=>1500.0, :charges_reelles=>15845.7375, :charges=>20750.0}}
  def total_cr(debut=nil, fin=nil)
    debut ||= self.debut.to_fr
    fin ||= self.fin.to_fr
    chs = self.chantiers.where.not(type_chantier: ['fonctionnement', 'hors_projet', 'conges'])


    paquet = chs.inject({
                          total_recettes_previ: 0, total_recettes_a_valider: 0,
                          total_charges_previ: 0, total_recettes_facturees: 0,
                          total_charges: 0, total_charges_reelles: 0
    }) do |sum, ch|
      sum[ch.code] = {}

      #previ
      recettes_previ = ch.total_recettes_previ[:total]
      recettes_a_valider = ch.total_recettes_previ[:a_valider]
      charges_previ = ch.total_charges_previ[:total]
      total_chantier_previ=recettes_previ - charges_previ

      sum[:total_recettes_previ] = sum[:total_recettes_previ] + recettes_previ
      sum[:total_recettes_a_valider] = sum[:total_recettes_a_valider] + recettes_a_valider
      sum[:total_charges_previ] = sum[:total_charges_previ] + charges_previ
      sum[ch.code] = {total_previ: total_chantier_previ, recettes_previ: recettes_previ, recettes_a_valider: recettes_a_valider, charges_previ: charges_previ}

      #reel
      total_recettes_facturees = ch.total_recettes_facturees(debut, fin)[:total]
      total_charges = ch.total_charges(debut, fin)[:total]
      total_charges_reelles = ch.total_charges(debut, fin)[:total_reel]

      sum[:total_recettes_facturees] = sum[:total_recettes_facturees] + total_recettes_facturees
      sum[:total_charges] = sum[:total_charges] + total_charges
      sum[:total_charges_reelles] = sum[:total_charges_reelles] + total_charges_reelles

      sum[ch.code].merge!({recettes_facturees: total_recettes_facturees, charges_reelles: total_charges_reelles, charges: total_charges})

      sum
    end
    paquet
  end

# retourne un tableau contenant les charges et les recettes et la part de la contribution
# ex: [{:total=>27132.16}, {:total=>162.1875, :total_contribution=>162.1875}] 

  def synthese_fonctionnement(debut=nil, fin=nil)

    debut ||= self.debut.to_fr
    fin ||= self.fin.to_fr

    chantiers_fonctionnement = self.chantiers.where(type_chantier: 'fonctionnement')
    charges_fonct = chantiers_fonctionnement.inject({total: 0}) do |c, chantier|
      c[:total] = c[:total] + chantier.total_charges(debut, fin)[:total_reel]
      c
    end
    recettes_fonct = chantiers_fonctionnement.inject({total: 0, total_contribution: 0}) do |r, chantier|
      total_r= chantier.total_recettes_facturees(debut, fin)
      r[:total] = r[:total] + total_r[:total]
      r[:total_contribution] = total_r[:total_contribution]
      r
    end
    return charges_fonct, recettes_fonct
  end

  def synthese_hors_projet(debut=nil, fin=nil)
    debut ||= self.debut.to_fr
    fin ||= self.fin.to_fr
    chantiers_hp = self.chantiers.where(type_chantier: 'hors_projet')
    charges_hp = chantiers_hp.inject({total: 0}) do |c, chantier|
      c[:total] = c[:total] + chantier.total_charges(debut, fin)[:total_reel]
      c
    end
    recettes_hp = chantiers_hp.inject({total: 0, total_contribution: 0}) do |r, chantier|
      total_r= chantier.total_recettes_facturees(debut, fin)
      r[:total] = r[:total] + total_r[:total]
      r[:total_contribution] = total_r[:total_contribution]
      r
    end
    return charges_hp, recettes_hp
  end

  
  # Retourne la totalité des charges pour les chantiers de type fonctionnement
  ## integre les charges ainsi que le personnel au réel sans les contributions bien évidememnt
  def total_charges_chantiers_hp_fonct(nom="fonctionnement")
    chantiers_contrib = self.chantiers.where(type_chantier: nom)
    etat_contrib = chantiers_contrib.inject({total: 0}) do |sum, cf|
      t = cf.total_charges[:total_reel]
      sum[:total] = sum[:total] + t
      sum[cf.code] ||=0
      sum[cf.code] = sum[cf.code] + t
      sum
    end
    return etat_contrib
  end

  # Retourne le total de la contribution des chantiers pour le fonctionnement/hp
  def total_contribution(nom="fonctionnement", debut=nil, fin=nil)
    debut ||= self.debut.to_fr
    fin ||= self.fin.to_fr
    
    chantiers_projets = self.chantiers.where(type_chantier: 'projet')

    # -- totalité des contributions aux fonctionnements
    contrib = chantiers_projets.inject({total: 0}) do |sum, cf|

      v = cf.jours_consommes(debut, fin)[:total]*self.contribution_fonct if nom=="fonctionnement"
      v = cf.jours_consommes(debut, fin)[:total]*self.contribution_hors_projet if nom=="hors_projet"
      sum[:total] = sum[:total] + v
      sum[cf.code] ||=0
      sum[cf.code] = sum[cf.code] + v
      sum
    end
    contrib
  end


end
