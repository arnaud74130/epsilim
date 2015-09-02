namespace :rapport_activite do
  include ActionView::Helpers::NumberHelper
  desc "rake rapport_activite:exercice[2014]"
  task :exercice, [:exercice] => :environment  do |task, args|
    ex=Exercice.find_by_code(args.exercice.to_i)
    b_contrib_hp=ex.contribution_hors_projet
    b_contrib_fct=ex.contribution_fonct
    ex.contribution_fonct=0
    ex.contribution_hors_projet=0
    ex.save

    # ----- ETP par POLE ---
    ETP={}
    ex.personnes.each do |p|
      unless p.suivi.empty?        
        tj = ex.nb_jours - p.suivi['CONGES']        
        p.suivi.except('CONGES').each do |code, nb|
          c = ex.chantiers.where(code: code).first
          ETP[c.pole] = 0 unless ETP[c.pole]
          ETP[c.pole] = ETP[c.pole] + nb/tj      
        end
      end
    end

    puts "-------------------------------------------------------"
    puts "                 APPROCHE GLOBALE                     "
    puts "-------------------------------------------------------"

    # --  nombre de jours
    nb_projet=nbr_jours_type_chantier(ex)
    
    # -- recettes
    recettes_charges_type(ex)
    r_fct, r_hp = synthese_recettes_chantiers(ex)
    

    # -- charges
    ch_p, ch_fct, ch_hp=synthese_charges_chantiers(ex)
    
    delta_fct= ch_fct-r_fct
    delta_hp= ch_hp-r_hp
    contrib_fct=delta_fct/nb_projet
    contrib_hp=delta_hp/nb_projet

    puts " ----- TOTAL PAR TYPE DE CHARGE -----"   
    type_charges(ex)

    puts " --- CONTRIBUTION FONCTIONNEMENT et HORS_PROJET---"
    puts "La part de la contribution pour le fonctionnement est de #{number_to_currency(delta_fct, unit: "€")}"
    puts "La part de la contribution pour le hors_projet est de #{number_to_currency(delta_hp, unit: "€")}"
    puts "Le nombre de jours projet est de #{nb_projet}"
    puts "Soit une contribution fonctionnement de #{number_to_currency(contrib_fct, unit: "€")}"
    puts "Soit une contribution fonctionnement de #{number_to_currency(contrib_hp, unit: "€")}"

    puts ""
    puts "Les charges projet sont passées par conséquent de #{number_to_currency(ch_p, unit: "€")} à #{number_to_currency(ch_p+delta_fct+delta_hp, unit: "€")}"

    puts "-------------------------------------------------------"
    puts "                 APPROCHE PAR POLE                     "
    puts "-------------------------------------------------------"
    
    
    puts "--- CHARGES PERSONNEL PAR POLE"
    synthese_charges_chantiers_pole(ex)

    puts "---- Recettes par PÔLE ---"    
    total_recettes_pole = 0
    ex.poles.each do |p|
      r = recettes_chantier_pole(ex,p)
      puts "   #{p.libelle}  total recettes = #{number_to_currency(r, unit: "€")}"
      total_recettes_pole = total_recettes_pole + r
    end
    puts "   ==> total des recettes des pôles = #{number_to_currency(total_recettes_pole, unit: "€")}"

    puts "--- Nombre d'ETP par pôle"
    total_etp =0.0
    ex.poles.each do |p|
      puts "   #{p.libelle}, #{ETP[p]} ETP"
      total_etp = total_etp + ETP[p] if ETP[p]
    end
    puts "   ==> total ETP salariés (sans mise à disposition) en #{ex.code} = #{total_etp} "


  
    puts " ---- TYPE DE CHARGE PAR POLE (HORS PERSONNELLES)                  "
    
    ex.poles.each do |pole|
      type_charges_pole(ex, pole)
    end
    

    
    #restore values
    ex.contribution_fonct=b_contrib_fct
    ex.contribution_hors_projet=b_contrib_hp
    ex.save

  end

  def synthese_recettes_chantiers(ex)
    cp=recettes_chantier_type(ex, 'projet')
    cm=recettes_chantier_type(ex, 'mission')
    cf=recettes_chantier_type(ex, 'fonctionnement')
    chp=recettes_chantier_type(ex, 'hors_projet')
    total_g = cp[:total]+cm[:total]+cf[:total]+chp[:total]
    total_p = cp['PERSONNEL']+cm['PERSONNEL']+cf['PERSONNEL']+chp['PERSONNEL']
    puts "--- RECETTES TOTALES[#{ex.nom}] = #{number_to_currency(total_g, unit: "€")}"
    puts "         PROJET           : #{number_to_currency(cp[:total], unit: "€")} "
    puts "         MISSION          : #{number_to_currency(cm[:total], unit: "€")} "
    puts "         FONCTIONNEMENT   : #{number_to_currency(cf[:total], unit: "€")} "
    puts "         HORS_PROJET      : #{number_to_currency(chp[:total], unit: "€")} "

    puts "--- RECETTES PERSONNEL[#{ex.nom}] = #{number_to_currency(total_p, unit: "€")}"
    puts "         PROJET           : #{number_to_currency(cp['PERSONNEL'], unit: "€")}"
    puts "         MISSION          : #{number_to_currency(cm['PERSONNEL'], unit: "€")}"
    puts "         FONCTIONNEMENT   : #{number_to_currency(cf['PERSONNEL'], unit: "€")}"
    puts "         HORS_PROJET      : #{number_to_currency(chp['PERSONNEL'], unit: "€")}"
    return cf[:total], chp[:total]
  end

  def recettes_chantier_type(ex, chantier_type)
    cp=ex.chantiers.where(type_chantier: chantier_type).inject({:total => 0.0,"PERSONNEL" => 0.0}) do |sum, r|

      sum[:total] = sum[:total] + r.total_recettes_a_valider[:total] if r.total_recettes_a_valider[:total]
      sum[:total] = sum[:total] + r.total_recettes_facturees[:total] if r.total_recettes_facturees[:total]
      sum["PERSONNEL"] = sum["PERSONNEL"] + r.total_recettes_a_valider["PERSONNEL"] if r.total_recettes_a_valider["PERSONNEL"]
      sum["PERSONNEL"] = sum["PERSONNEL"] +r.total_recettes_facturees["PERSONNEL"] if r.total_recettes_facturees["PERSONNEL"]
      sum
    end
    cp
  end

  def synthese_charges_chantiers(ex)
    cp=charges_chantier_type(ex, 'projet')
    cm=charges_chantier_type(ex, 'mission')
    cf=charges_chantier_type(ex, 'fonctionnement')
    chp=charges_chantier_type(ex, 'hors_projet')

    total_md = cp['PERSONNEL_MANUELLE'] + cm['PERSONNEL_MANUELLE'] + cf['PERSONNEL_MANUELLE'] + chp['PERSONNEL_MANUELLE']
    total_p = cp['PERSONNEL_REELLE'] + cm['PERSONNEL_REELLE'] + cf['PERSONNEL_REELLE'] + chp['PERSONNEL_REELLE']
    total_g=cp[:total_reel] + cm[:total_reel] + cf[:total_reel] + chp[:total_reel]

    puts "--- CHARGES TOTALES[#{ex.nom}] = #{number_to_currency(total_g, unit: "€")}"
    puts "         PROJET           : #{number_to_currency(cp[:total_reel], unit: "€")} "
    puts "         MISSION          : #{number_to_currency(cm[:total_reel], unit: "€")} "
    puts "         FONCTIONNEMENT   : #{number_to_currency(cf[:total_reel], unit: "€")} "
    puts "         HORS_PROJET      : #{number_to_currency(chp[:total_reel], unit: "€")} "

    puts "--- CHARGES PERSONNEL[#{ex.nom}] = #{number_to_currency(total_p, unit: "€")} dont mises à dispotion #{number_to_currency(total_md, unit: "€")}"
    puts "         PROJET           : #{number_to_currency(cp['PERSONNEL_REELLE'], unit: "€")} dont mises à disposition #{number_to_currency(cp['PERSONNEL_MANUELLE'], unit: "€")}"
    puts "         MISSION          : #{number_to_currency(cm['PERSONNEL_REELLE'], unit: "€")} dont mises à disposition #{number_to_currency(cm['PERSONNEL_MANUELLE'], unit: "€")}"
    puts "         FONCTIONNEMENT   : #{number_to_currency(cf['PERSONNEL_REELLE'], unit: "€")} dont mises à disposition #{number_to_currency(cf['PERSONNEL_MANUELLE'], unit: "€")}"
    puts "         HORS_PROJET      : #{number_to_currency(chp['PERSONNEL_REELLE'], unit: "€")} dont mises à disposition #{number_to_currency(chp['PERSONNEL_MANUELLE'], unit: "€")}"
    return cp[:total_reel], cf[:total_reel], chp[:total_reel]
  end

  def synthese_charges_chantiers_pole(ex)  
    total = 0.0      
    total_all = 0.0    
    ex.poles.each do |pole|
      c = charges_chantier_pole(ex, pole)
      puts "         #{pole.libelle}           : TOTAL des charges = #{number_to_currency(c[:total_reel], unit: "€")} dont #{number_to_currency(c['PERSONNEL_REELLE']+c['PERSONNEL_MANUELLE'], unit: "€")} de personnel"
      total = total + c['PERSONNEL_REELLE']      
      total_all = total_all + c[:total_reel]
    end
    puts "         => TOTAL global des charges est de #{number_to_currency(total_all, unit: "€")}, dont #{number_to_currency(total, unit: "€")} de personnel"

  end
  def charges_chantier_type(ex, chantier_type)
    cp=ex.chantiers.where(type_chantier: chantier_type).inject({:total_reel => 0.0,"PERSONNEL_REELLE" => 0.0, "PERSONNEL_MANUELLE" => 0.0}) do |sum, c|
      sum[:total_reel] = sum[:total_reel] + c.total_charges[:total_reel] if c.total_charges[:total_reel]
      sum['PERSONNEL_REELLE'] = sum['PERSONNEL_REELLE'] + c.total_charges['PERSONNEL_REELLE'] if c.total_charges['PERSONNEL_REELLE']
      sum['PERSONNEL_MANUELLE'] = sum['PERSONNEL_MANUELLE'] + c.total_charges['PERSONNEL_MANUELLE'] if c.total_charges['PERSONNEL_MANUELLE']
      sum
    end
    cp
  end

 def charges_chantier_pole(ex, pole)
    cp=ex.chantiers.where(pole: pole).inject({:total_reel => 0.0,"PERSONNEL_REELLE" => 0.0, "PERSONNEL_MANUELLE" => 0.0}) do |sum, c|
      sum[:total_reel] = sum[:total_reel] + c.total_charges[:total_reel] if c.total_charges[:total_reel]
      sum['PERSONNEL_REELLE'] = sum['PERSONNEL_REELLE'] + c.total_charges['PERSONNEL_REELLE'] if c.total_charges['PERSONNEL_REELLE']
      sum['PERSONNEL_MANUELLE'] = sum['PERSONNEL_MANUELLE'] + c.total_charges['PERSONNEL_MANUELLE'] if c.total_charges['PERSONNEL_MANUELLE']
      sum
    end
    cp
  end
  def recettes_chantier_pole(ex, pole)
    cp=ex.chantiers.where(pole: pole).inject(0) do |sum, c|
      sum = sum + c.total_recettes_facturees[:total]
      sum
    end
    
  end
  def recettes_charges_type(ex)
    puts "--- TYPE DE FINANCEMENT (RECETTES FACTURÉES) [#{ex.nom}]"
    ex.type_financements.each do |tf|
      mf=Recette.where(type_financement: tf, mode: "facturee").inject(0){|sum, r| sum = sum + r.montant}.to_f
      puts "          #{tf.nom} = #{number_to_currency(mf, unit: "€")}"  unless mf==0
    end

    puts "--- TYPE DE FINANCEMENT (RECETTES A VALIDER) [#{ex.nom}]"
    ex.type_financements.each do |tf|
      mf=Recette.where(type_financement: tf, mode: "a_valider").inject(0){|sum, r| sum = sum + r.montant}.to_f      
      puts "          #{tf.nom} en #{tf.exercice.nom} = #{number_to_currency(mf, unit: "€")}" unless mf==0
    end
  end
  def type_charges_pole(ex, pole)
    puts "  [#{pole.libelle}]"
    t=0.0
    periode_debut=ex.debut
    periode_fin=ex.fin
    ex.type_charges.each do |tf|
      unless tf.nom=="PERSONNEL"
        total_tf=0.0
        ex.chantiers.where(pole: pole).each do |c|                    
          total_tf=total_tf+c.charges.where(type_charge: tf, previ: false).where('periode_debut >= ?', periode_debut).where('periode_debut <= ?', periode_fin).inject(0) do |sum,ch| 
            sum=sum+ch.coupure(ex.debut,ex.fin)
            if ch.coupure(ex.debut,ex.fin)==-Float::INFINITY
              puts "ERROR sur la charge id= #{ch.id}"
            end
            sum
          end

        end
        puts "          #{tf.nom} = #{number_to_currency(total_tf, unit: "€")}" unless total_tf==0        
        t=t+total_tf
      end
    end
    puts "                ==>Total = #{number_to_currency(t, unit: "€")}"
  end

  def type_charges(ex)   
    t=0.0
    periode_debut=ex.debut
    periode_fin=ex.fin
    ex.type_charges.each do |tf|
      unless tf.nom=="PERSONNEL"
        total_tf=0.0
        ex.chantiers.each do |c|                    
          total_tf=total_tf+c.charges.where(type_charge: tf, previ: false).where('periode_debut >= ?', periode_debut).where('periode_debut <= ?', periode_fin).inject(0) do |sum,ch| 
            sum=sum+ch.coupure(ex.debut,ex.fin)
            if ch.coupure(ex.debut,ex.fin)==-Float::INFINITY
              puts "ERROR sur la charge id= #{ch.id}"
            end
            sum
          end

        end
        puts "          #{tf.nom} = #{number_to_currency(total_tf, unit: "€")}" unless total_tf==0        
        t=t+total_tf
      end
    end
    puts "                ==>Total = #{number_to_currency(t, unit: "€")}"
  end

  def nbr_jours_type_chantier(ex)
    puts "---- NOMBRE DE JOURS PAR TYPE DE CHANTIER [#{ex.nom}] ----"

    nbj_fct=ex.chantiers.where(type_chantier: 'fonctionnement').inject(0) {|sum, c| sum = sum +c.jours_consommes[:total]}
    nbj_hp=ex.chantiers.where(type_chantier: 'hors_projet').inject(0) {|sum, c| sum = sum +c.jours_consommes[:total]}
    nbj_p=ex.chantiers.where(type_chantier: 'projet').inject(0) {|sum, c| sum = sum +c.jours_consommes[:total]}
    nbj_m=ex.chantiers.where(type_chantier: 'mission').inject(0) {|sum, c| sum = sum +c.jours_consommes[:total]}
    nbj_c=ex.chantiers.where(type_chantier: 'conges').inject(0) {|sum, c| sum = sum +c.jours_consommes[:total]}
    puts "          Fonctionnement    : #{nbj_fct} j"
    puts "          Hors_projet       : #{nbj_hp} j"
    puts "          Projet            : #{nbj_p} j"
    puts "          Mission           : #{nbj_m} j"
    puts "          Congés            : #{nbj_c} j"
    nbj_p
  end
end
