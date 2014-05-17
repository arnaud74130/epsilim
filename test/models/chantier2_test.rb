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

require 'test_helper'

class ChantierTest < ActiveSupport::TestCase
	
	def assert_equal_float(expected, actual, message="") 
		assert_equal expected.to_f.round(2), actual.to_f.round(2),message
	end
# -------------------- Jours consommés -------------
	test "jours consommes" do
		 dmp = chantiers(:dmp)
		 assert_equal 1.25, dmp.jours_consommes[:total], "Retourne le nombre de jours consommes sur l'exercice entier"
		 assert_equal 0.25, dmp.jours_consommes("1/1/2013","2/1/2013")[:total], "Retourne le nombre de jours consommes sur une période"
		 assert_equal 1, dmp.jours_consommes("1/05/2013","1/05/2013")[:total], "Retourne le nombre de jours consommes sur une période"
		 assert_equal 1.25, dmp.jours_consommes("1/1/2013","2/05/2013")[:total], "Retourne le nombre de jours consommes sur une période"		   
	end

# ------------------------------------------
#         			RECETTES
# ------------------------------------------

	test "recettes previ" do
		dmp = chantiers(:dmp)
		assert_equal 7750, dmp.total_recettes_previ[:total], "Recettes prévisionnelles, [DMP]"	
		assert_equal 6750, dmp.total_recettes_previ[:a_valider], "Recettes prévisionnelles à valider, [DMP]"				
	end

	test "recettes a valider" do
		dmp = chantiers(:dmp)
		assert_equal 6750, dmp.total_recettes_a_valider[:total], "total des recettes à valider, [DMP]"	
		assert_equal 1750.0, dmp.total_recettes_a_valider["INVESTISSEMENT"], "total des recettes à valider de type INVESTISSEMENT, [DMP]"	
		
	end

	test "recettes facturees" do
		dmp = chantiers(:dmp)
		assert_equal 1500, dmp.total_recettes_facturees[:total], "total des recettes facturées, [DMP]"
	end
	
	test "recettes facturees sur une periode" do
		dmp = chantiers(:dmp)
		# situation entre le 1er janvier (j=1) et le 1er Mars 2013 (j=60)
		assert_equal_float 59*500/364.0, dmp.total_recettes_facturees("1/1/2013","1/3/2013")[:total], "Recettes facturées sur une période, [DMP]"
		# situation entre le 1er janvier (j=1) et le 1er Juillet 2013 (j=182), 1er Avril étant le 91ème jours
		p=(182-91).to_f/(365-91)
		p2=(182-1).to_f/(365-1)
		assert_equal_float (p2*500+p*1000), dmp.total_recettes_facturees("1/1/2013","1/7/2013")[:total], "Recettes facturées sur deux périodes, [DMP]"
		assert_equal_float 500, dmp.total_recettes_facturees["PERSONNEL"], "Recettes facturées sur deux périodes de PERSONNEL, [DMP]"
	end

	test "recettes facturees sur une periode pour le fonctionnement" do
		fonct = chantiers(:fonct)
		#jours_consommes("01/01/2013","01/03/2013") ==> {:total=>4.5, "CTS"=>2.5, "AGA"=>2.0}
		r = fonct.total_recettes_facturees("01/01/2013","01/03/2013")		
		assert_equal_float (2.5*396+2*614),r[:total], "recettes fonctionnement sur une période [FONCT]"
		assert_equal_float (2.5*396+2*614),r[:total_contribution], "Contribution recettes fonctionnement sur une période [FONCT]"
		#TODO ajouter des recettes autres que personnel pour vérifier correctement
		
	end

# ------------------------------------------
#         			CHARGES
# ------------------------------------------
	#-- PREVI
	test "charges prévisionnelles" do
		dmp = chantiers(:dmp)
		charges = dmp.total_charges_previ
		assert_equal 12543.0, charges["INFORMATIQUE"], "charges informatique, [DMP]"
		assert_equal 10000, charges["PERSONNEL"], "charges personnel, [DMP]"	
		assert_equal 22543.0, charges[:total]
	end

	#-- SANS PERIODE
	test "charges informatique" do
		dmp = chantiers(:dmp)
		charges = dmp.total_charges
		assert_equal 10125.0, charges["INFORMATIQUE"], "charges informatique [DMP]"		
	end

	test "charges chantiers fonctionnement" do
		fonct = chantiers(:fonct)
		charges = fonct.total_charges
		assert_equal 24260.7, charges["LOCAUX"], "charges locaux [FONCTIONNEMENT]"	
		assert_equal 158.46, charges["INFORMATIQUE"], "charges informatique [FONCTIONNEMENT]"	
	end

	test "charges personnel" do
		dmp = chantiers(:dmp)
		charges = dmp.total_charges
		#FIXME total faux, les charges personnel hors activité (5000) sont ajoutée dans le total => 5000 de trop	
		assert_equal 1.25*500+5000, charges["PERSONNEL"], "charges personnel vue financeur, [DMP]"	
		#FIXME personnel réelle faux, les charges personnel hors activité 5000 ne sont pas pris en compte
		assert_equal 1.25*(396+129.75+50.84)+5000, charges["PERSONNEL_REELLE"], "Total des charges réelles de personnel, [DMP]"
	
	end
	
	test "total des charges" do
		dmp = chantiers(:dmp)
		charges = dmp.total_charges
		assert_equal_float 15750, charges[:total], "TOTAL charges (vue financeur), [DMP]" 
		assert_equal_float 10125+5720.7375, charges[:total_reel], "TOTAL des charges réelles, [DMP]"
	end

	#-- AVEC PERIODE
	test "charges informatique sur periode" do
		dmp = chantiers(:dmp)
		charges = dmp.total_charges("01/01/2013","01/04/2013")
		p=(91-1).to_f/(181-1)		
		p2=(91-1).to_f/(365-1)
		assert_equal_float (2500*p+7625*p2), charges["INFORMATIQUE"], "Charges informatique sur période, [DMP]"
	end

	test "charges personnel sur periode" do
		dmp = chantiers(:dmp)
		p=(91-1).to_f/(181-1)
		charges = dmp.total_charges("01/01/2013","01/04/2013")		
		assert_equal_float (0.25*500+5000*p), charges["PERSONNEL"], "Charges de personnel sur période, [DMP]"
		assert_equal_float (0.25*(396+129.75+50.84)+5000*p), charges["PERSONNEL_REELLE"], "Charges de personnel réelles sur période, [DMP]"
	end

	test "total des charges réelles" do
		dmp = chantiers(:dmp)
		charges = dmp.total_charges
		assert_equal_float 15750, charges[:total], "TOTAL charges sur période (vue financeur), [DMP]" 
		assert_equal_float 10125+5720.7375, charges[:total_reel], "TOTAL des charges réelles sur une période, [DMP]"

	end
end