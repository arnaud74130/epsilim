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
    
  
    nb_projet=nbr_jours_type_chantier(ex)
    
    recettes_charges_type(ex)
    r_fct, r_hp = synthese_recettes_chantiers(ex)
    

    
    ch_p, ch_fct, ch_hp=synthese_charges_chantiers(ex)
    
    delta_fct= ch_fct-r_fct
    delta_hp= ch_hp-r_hp
    contrib_fct=delta_fct/nb_projet
    contrib_hp=delta_hp/nb_projet
    
    puts "--- CHARGES PAR PÔLE (HORS PERSONNELLES) ---"
    type_charges_pole(ex, 'projet')
    type_charges_pole(ex, 'mission')    
    type_charges_pole(ex, 'fonctionnement')
    type_charges_pole(ex, 'hors_projet')

    type_charges(ex)
    
    puts " --- CONTRIBUTION FONCTIONNEMENT et HORS_PROJET---"
    puts "La part de la contribution pour le fonctionnement est de #{number_to_currency(delta_fct, unit: "€")}"
    puts "La part de la contribution pour le hors_projet est de #{number_to_currency(delta_hp, unit: "€")}"
    puts "Le nombre de jours projet est de #{nb_projet}"
    puts "Soit une contribution fonctionnement de #{number_to_currency(contrib_fct, unit: "€")}"
    puts "Soit une contribution fonctionnement de #{number_to_currency(contrib_hp, unit: "€")}"

    puts ""
    puts "Les charges projet sont passées par conséquent de #{number_to_currency(ch_p, unit: "€")} à #{number_to_currency(ch_p+delta_fct+delta_hp, unit: "€")}"
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

  def charges_chantier_type(ex, chantier_type)
    cp=ex.chantiers.where(type_chantier: chantier_type).inject({:total_reel => 0.0,"PERSONNEL_REELLE" => 0.0, "PERSONNEL_MANUELLE" => 0.0}) do |sum, c|
      sum[:total_reel] = sum[:total_reel] + c.total_charges[:total_reel] if c.total_charges[:total_reel]
      sum['PERSONNEL_REELLE'] = sum['PERSONNEL_REELLE'] + c.total_charges['PERSONNEL_REELLE'] if c.total_charges['PERSONNEL_REELLE']
      sum['PERSONNEL_MANUELLE'] = sum['PERSONNEL_MANUELLE'] + c.total_charges['PERSONNEL_MANUELLE'] if c.total_charges['PERSONNEL_MANUELLE']
      sum
    end
    cp
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
    puts "  [#{pole.upcase}]"
    t=0.0
    periode_debut=ex.debut
    periode_fin=ex.fin
    ex.type_charges.each do |tf|
      unless tf.nom=="PERSONNEL"
        total_tf=0.0
        ex.chantiers.where(type_chantier: pole).each do |c|                    
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
  puts " ======= TYPE DE CHARGE ============"   
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
