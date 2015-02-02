namespace :rapport_activite do
  include ActionView::Helpers::NumberHelper
  desc "rake rapport_activite:exercice[2014]"
  task :exercice, [:exercice] => :environment  do |task, args|
    ex=Exercice.find_by_code(args.exercice.to_i)

    recettes_charges_type(ex)
    nbr_jours_type_chantier(ex)
    synthese_charges_chantiers(ex)
    synthese_recettes_chantiers(ex)

  end

  def synthese_recettes_chantiers(ex)
    cp=recettes_chantier_type(ex, 'projet')
    cm=recettes_chantier_type(ex, 'mission')
    cf=recettes_chantier_type(ex, 'fonctionnement')
    chp=recettes_chantier_type(ex, 'hors_projet')
    ex.contribution_hors_projet==0
    ex.contribution_fonct==0.0
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
    
    ex.contribution_hors_projet==0
    ex.contribution_fonct==0.0

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
    puts "--- RECETTES FACTURÉES"
    ex.type_financements.each do |tf|
      mf=Recette.where(type_financement: tf, mode: "facturee").inject(0){|sum, r| sum = sum + r.montant}.to_f
      puts "          #{tf.nom} en #{tf.exercice.nom} est #{number_to_currency(mf, unit: "€")}"
    end

    puts "--- RECETTES A VALIDER"
    ex.type_financements.each do |tf|
      mf=Recette.where(type_financement: tf, mode: "a_valider").inject(0){|sum, r| sum = sum + r.montant}.to_f
      puts "          #{tf.nom} en #{tf.exercice.nom} est #{number_to_currency(mf, unit: "€")}"
    end

    puts "--- CHARGES ---"
    ex.type_charges.each do |tf|
      unless tf.nom=="PERSONNEL"
        mf=Charge.where(type_charge: tf, previ: false).inject(0){|sum, r| sum = sum + r.montant}.to_f
        puts "          #{tf.nom} en #{tf.exercice.nom} est #{number_to_currency(mf, unit: "€")}"
      end
    end
  end

  def nbr_jours_type_chantier(ex)
    puts "---- NOMBRE DE JOURS PAR TYPE DE CHANTIER----"

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

  end
end
