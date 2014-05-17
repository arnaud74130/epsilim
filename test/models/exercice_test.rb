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

class ExericeTest < ActiveSupport::TestCase

	def assert_equal_float(expected, actual, message="") 
		assert_equal expected.to_f.round(2), actual.to_f.round(2),message
	end

	test "total contribution" do
		ex=exercices(:two)
		# Contribution HP = 50.84
		# Contribution Fonctionnement = 129.75
		# 1 seul projet contribuant, le DMP à hauteur de 1,25 jour
		assert_equal_float 1.25*129.75, ex.total_contribution("fonctionnement")[:total],"Total contribution fonctionnement"
		assert_equal_float 1.25*50.84, ex.total_contribution("hors_projet")[:total],"Total contribution hors projet"
	end
	
	test "total des charges fonct_hp" do
		ex=exercices(:two)
		# intègre les charges ainsi que le personnel au réel sans les contributions bien évidememnt
		assert_equal_float 27132.16, ex.total_charges_chantiers_hp_fonct("fonctionnement")[:total],"Total des charges de fonctionnement"		
	end

end