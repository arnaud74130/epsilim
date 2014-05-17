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

class PersonneTest < ActiveSupport::TestCase
  setup do
    @exercice = exercices(:two)
  end
# ---------------- DIVERS ----------------
  test "Nom complet" do
    cts=personnes(:cts)
    assert_equal "TERMENS Caroline", cts.full_name
  end
# ---------------- S U I V I ----------------
  test "suivi de d'un chantier sans période" do
    cts=personnes(:cts)
    res = cts.suivi(chantier_id: 220)
    assert_equal 3.75, res["FONCT"], "Nombre de jours attendu au fonctionnement"
  end

  
  test "suivi de d'un chantier avec une période" do
    cts=personnes(:cts)
    res = cts.suivi(chantier_id: 220, annee: 2013, mois: 1, mois2: 2, annee2: 2013)
    assert_equal 1.5, res["FONCT"], "Nombre de jours attendu au fonctionnement"

    res = cts.suivi(chantier_id: 220, annee: 2013, mois: 3, mois2: 4, annee2: 2013)
    assert_equal 2, res["FONCT"], "Nombre de jours attendu au fonctionnement"
  end

  test "suivi de tous les chantiers sans période" do
    cts=personnes(:cts)
    res = cts.suivi
    assert_equal 3.75, res["FONCT"], "Nombre de jours attendu au fonctionnement"
    assert_equal 1.25, res["DMP1"], "Nombre de jours attendu pour le DMP"
  end

  test "suivi de tous les chantiers avec période" do
    cts=personnes(:cts)
    res = cts.suivi(annee: 2013, mois: 1, mois2: 2, annee2: 2013)
    assert_equal 1.5, res["FONCT"], "Nombre de jours attendu au fonctionnement"
    assert_equal 0.25, res["DMP1"], "Nombre de jours attendu pour le DMP"
  end


  # ---------------- ACTIVITES sur jour/année ----------------
  test "activite sur un jour annee" do
    cts=personnes(:cts)
    assert_equal "FONCT", cts.activites_jour_annee(32,2013).first.chantier.code
  end
# ---------------- R O L E S ----------------
test "has_one_role" do
    cts=personnes(:cts)
    assert cts.has_role?(:direction)
    assert cts.has_role?("direction")
    assert !cts.has_role?(:cp)
  end

  test "automatic_is_role?" do
    aga = personnes(:aga)
    assert aga.is_direction?
    cts = personnes(:cts)
    assert cts.is_direction?
    assert !cts.is_cp?
  end

  test "nil_role" do
    cts_ex1=personnes(:cts_ex1)
    assert !cts_ex1.has_role?(nil)
  end

  test "has_one_role_from_many" do
    aga = personnes(:aga)
    assert aga.has_role?(:direction)
  end

  test "multiples_roles" do
    cts = personnes(:test)
    assert cts.has_role?("direction,cp")
    #assert !cts.has_role?("direction,cp")
    assert cts.has_role?(["direction","cp"])
    assert cts.has_role?([:direction, :cp, nil])
  end
end
