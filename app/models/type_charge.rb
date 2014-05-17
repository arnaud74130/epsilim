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

class TypeCharge < ActiveRecord::Base
	 default_scope {order('poids ASC')}
	before_save :pretty_record

	has_many :type_charge_chantiers
	has_many :charges, through: :type_charge_chantiers, source: :type_charge, dependent: :destroy
	belongs_to :exercice

	def pretty_record
		self.nom=nom.upcase
	end
end
