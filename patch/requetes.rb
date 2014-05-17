class Requetes
	def initialize
		ActiveRecord::Base.logger = nil
	end
	def projets(numero_exercice)
		ex=Exercice.find(numero_exercice)
		file=File.open("projet_a_valider.csv","w")
		ex.chantiers.each do |chantier|
			file.puts("#{chantier.code},#{chantier.total_recettes(a_valider: :t)[:total]}\n")
		end
		file.close
	end
	def situation(numero_exercice)
		ex=Exercice.find(numero_exercice)
		file=File.open("situations.csv","w")
		ex.chantiers.each do |chantier|
			jours = chantier.jours_consommes[:total]
			charges = chantier.total_charges
			file.puts("#{chantier.code},#{jours}, #{charges["PERSONNEL"]}, #{charges["SOUS-TRAITANCE"]},#{charges["INVESTISSEMENT"]}, #{charges[:total]}, \n")
		end
		file.close
		
	end
	def a_valider_previ
		Recette.all.each do |r|
			r.mode = "a_valider" if r.a_valider
			r.mode = "previ" if r.previ
			r.save
		end
	end
end