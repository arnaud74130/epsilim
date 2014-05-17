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

namespace :import do
  require 'csv'
  desc "rake import:setup_epsilim[2014]"
  task :setup_epsilim, [:exercice] => :environment  do |task, args|
    ex= Exercice.create(nom: args.exercice.to_s, code: args.exercice.to_i, debut: "01/01/#{args.exercice.to_s}", fin: "31/12/#{args.exercice.to_s}")
    Personne.create(nom: 'ADMIN', prenom: 'admin', initiale: 'aga', mail: 'foo@gcs.fr', username: 'admin', password: 'epsilim', roles: 'direction', exercice: ex)
    TypeCharge.create(nom: 'PERSONNEL', poids: 1, exercice: ex)
    TypeRecette.create(nom: 'PERSONNEL', poids: 1, exercice: ex)
    TypeRecette.create(nom: 'FONCTIONNEMENT', poids: 5, exercice: ex)
    TypeRecette.create(nom: 'HORS_PROJET', poids: 6, exercice: ex)
    TypeFinancement.create(nom: 'ARS', exercice: ex)

  end

  desc "Clone les type charges/financements/recettes/fournisseurs/chantier/personne d'un exercice vers un autre : rake import:clone_types[2012,2013]"
  task :clone_types, [:exercice1, :exercice2] => :environment  do |task, args|
    exercice1= Exercice.find_by_code(args.exercice1.to_i)
    exercice2= Exercice.find_by_code(args.exercice2.to_i)
    # -- TypeCharge
    exercice1.type_charges.each do |p|
      p2=p.dup
      p2.type_charge_id=p.id
      p2.exercice=exercice2
      p2.save
    end
    #-- TypeRecette
    exercice1.type_recettes.each do |p|
      p2=p.dup
      p2.type_recette_id=p.id
      p2.exercice=exercice2
      p2.save
    end
    #-- TypeFinancement
    exercice1.type_financements.each do |p|
      p2=p.dup
      p2.type_financement_id=p.id
      p2.exercice=exercice2
      p2.save
    end
    #-- Fournisseurs
    exercice1.fournisseurs.each do |p|
      p2=p.dup
      p2.fournisseur_id=p.id
      p2.exercice=exercice2
      p2.save
    end
    #-- Chantiers
    exercice1.chantiers.each do |p|
      p2=p.dup
      p2.chantier_id=p.id
      p2.exercice=exercice2
      p2.save
    end
    #-- Personnnes
    exercice1.personnes.each do |p|
      p2=p.dup
      p2.personne_id=p.id
      p2.exercice=exercice2
      p2.username = p2.initiale.downcase+exercice2.nom
      p2.password = p2.prenom.downcase+"87"
      p2.password_confirmation = p2.prenom.downcase+"87"
      p2.save
    end
  end



  desc "importation des fournisseurs pour un exercice : rake import:fournisseurs[2012]"
  # le fichier doit se trouver sous data/code de l'exercice/fournisseurs.csv
  task :fournisseurs, [:exercice] => :environment  do |task, args|
    CSV.foreach("data/#{args.exercice}/fournisseurs.csv",{:col_sep => ";", :headers =>true}) do |row|
      nom=row[0]
      contact=row[1]
      tel=row[2]
      email=row[3]
      exercice= Exercice.find_by_code(args.exercice.to_i)
      Fournisseur.create(exercice: exercice, nom: nom, contact: contact, tel: tel, email: email)
    end
  end


  desc "importation des charges réelles : ex: rake import:charges[2012,84,6,'data/2012/84/sous-traitance.csv'], charges de sous-traitance id=6, chantier dmp1 code=84 de l'exercice code=2012"
  # le fichier doit se trouver sous data/code de l'exercice/personnes.csv
  task :charges, [:exercice, :code_chantier, :type_charge_id, :chemin, :check] => :environment  do |task, args|
    check=args.check == "True"
    puts "Importation des charges : "

    CSV.foreach("#{args.chemin}",{:col_sep => "\t", :headers =>true}) do |row|

      row[0] ? date_recep=Date.strptime(row[0], "%d/%m/%y") : date_recep=nil
      fournisseur_nom=row[1]
      nature=row[2]
      row[3] ? date_paiement=Date.strptime(row[3], "%d/%m/%y") : date_paiement=nil
      montant=row[4].gsub(/\s/, "").gsub(/\u{a0}/, "").gsub(/€/,"").gsub(",",".").to_f
      puts " #{row[4]} -> montant :#{montant}"
      exercice= Exercice.find_by_code(args.exercice.to_i)
      chantier=exercice.chantiers.find_by_numero(args.code_chantier)


      fournisseur_nom ? fournisseur = Fournisseur.where('nom LIKE ?', '%'+fournisseur_nom+'%').first : fournisseur = nil
      unless fournisseur
        puts "Attention fournisseur absent : #{date_recep} | #{fournisseur} | #{nature} | #{date_paiement} | #{montant}"
      end
      type_charge = nil
      unless chantier.type_charges.empty?
        type_charge = chantier.type_charges.where(id: args.type_charge_id.to_i).first
      end
      unless type_charge
        type_charge = TypeCharge.find(args.type_charge_id.to_i)
        TypeChargeChantier.create(chantier: chantier, type_charge: type_charge) unless check
      end
      Charge.create(chantier: chantier, type_charge: type_charge, previ: :false, reception: date_recep, nature: nature, paiement: date_paiement, fournisseur: fournisseur, montant: montant) unless check

    end
  end

  desc "importation des personnes pour un exercice : rake import:personnes[2012]"
  # le fichier doit se trouver sous data/code de l'exercice/personnes.csv
  task :personnes, [:exercice] => :environment  do |task, args|
    CSV.foreach("data/#{args.exercice}/personnes.csv",{:col_sep => ";", :headers =>true}) do |row|
      nom=row[0]
      prenom=row[1]
      initiale=row[2]
      mail=row[3]
      exercice= Exercice.find_by_code(args.exercice.to_i)
      Personne.create(exercice: exercice, nom: nom, prenom: prenom, initiale: initiale, mail: mail)
    end
  end

  desc "importation des chantiers pour un exercice : rake import:chantiers[2012]"
  # le fichier doit se trouver sous data/code de l'exercice/chantiers.csv
  task :chantiers, [:exercice] => :environment  do |task, args|
    # Chantier.delete_all
    CSV.foreach("data/#{args.exercice}/chantiers.csv",{:col_sep => ";", :headers =>true}) do |row|
      code=row[0]
      numero=row[1]
      description=row[2]
      exercice= Exercice.find_by_code(args.exercice.to_i)

      Chantier.create(exercice: exercice, code: code, numero: numero, libelle: description)
    end
  end

  # desc "Ajout tous les chantiers à une personne : rake import:add_all_chantier_2012[BARDET]"
  # task :add_all_chantier_2012, [:nom] => :environment do |task, args|
  # 	personne=Personne.find_by_nom(args.nom)
  # 	puts "=> ajout des chantiers pour #{personne.nom} #{personne.prenom} :"
  # 	Chantier.all.each do |chantier|
  # 		Chantierpersonne.create(personne: personne, chantier: chantier)
  # 	end
  # end

  desc "Importation de l'activite d'une personne: rake import:activite[1,CTS,'data/2012/activite/termens.csv'] SANS ESPACE entre les paramètres"
  task :activite, [:exercice, :initiale, :chemin] => :environment  do |task, args|

    exercice=Exercice.find(args.exercice.to_i)
    personne=exercice.personnes.find_by_initiale(args.initiale)
    personne.activites.delete_all
    puts "=> (Exercice : #{exercice.code}) - Importation de #{personne.nom} #{personne.prenom} :"
    save=false
    cpt=0
    chantier=Array.new
    jour=Array.new
    annee=Array.new
    poids=Array.new
    sdate=Array.new
    ligne=0
    CSV.foreach("#{args.chemin}",{:col_sep => "\t"}) do |row|
      ligne=ligne+1
      puts "[#{ligne}] #{row}"
      chantier[cpt]=row[0]

      date=Date.strptime(row[2], '%d/%m/%Y')
      jour[cpt]=date.yday
      annee[cpt]=date.year
      sdate[cpt]=row[2]
      temp=row[2]
      poids[cpt]=row[3].gsub(',','.')

      if (cpt!=0 && temp!=sdate[cpt-1]) #on change de jour
        poids_temp=Array.new
        for i in 0..cpt-1
          poids_temp[i]=poids[i]
        end
        if poids_temp.include?("0.25")
          for i in 0..cpt-1
            ch=exercice.chantiers.find_by_code(chantier[i])
            if poids[i]=="0.25"
              Activite.create(personne: personne, chantier: ch, jour: jour[i], annee: annee[i], uid: SecureRandom.uuid)
              update_chantierpersonnes(personne, ch)
            else
              nb=poids[i].to_f.div(0.25)
              for j in 1..nb
                Activite.create(personne: personne, chantier: ch, jour: jour[i], annee: annee[i], uid: SecureRandom.uuid)
                update_chantierpersonnes(personne, ch)
              end
            end
          end
        else
          for i in 0..cpt-1
            ch=exercice.chantiers.find_by_code(chantier[i])
            Activite.create(personne: personne, chantier: ch, jour: jour[i], annee: annee[i], uid: SecureRandom.uuid)
            update_chantierpersonnes(personne, ch)
          end
        end
        # reset des tableaux
        tchantier=chantier[cpt]
        tjour=jour[cpt]
        tannee=annee[cpt]
        tsdate=sdate[cpt]
        tpoids=poids[cpt]

        chantier.clear
        jour.clear
        annee.clear
        sdate.clear
        poids.clear

        # recopier les éléments cpt en 0
        chantier[0]=tchantier
        jour[0]=tjour
        annee[0]=tannee
        sdate[0]=tsdate
        poids[0]=tpoids
        cpt=0 # inc ligne suivante car cpt doit valoir 1

      end
      cpt=cpt+1
    end

    # -- sauvegarde du dernier élément
    for i in 0..cpt-1
      ch=exercice.chantiers.find_by_code(chantier[i])
      Activite.create(personne: personne, chantier: ch, jour: jour[i], annee: annee[i], uid: SecureRandom.uuid)
      update_chantierpersonnes(personne, ch)
    end
  end
end

def update_chantierpersonnes(personne, chantier)
  cp = Chantierpersonne.where(personne: personne, chantier: chantier)
  if cp.size==0

    Chantierpersonne.create(personne: personne, chantier: chantier)
  end
end
