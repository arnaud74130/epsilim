require 'test_helper'

class ChargesControllerTest < ActionController::TestCase
  setup do
    @exercice = exercices(:two)
    @chantier = chantiers(:fonct)
  end

  test "synthese charges" do
    # get :index, {exercice_id: @exercice, chantier_id: @chantier}, {user_id: 1}
    # assert_response :success
    # assert_equal 24419.16+5.75*500, assigns(:total), "Total des charges réelles"

    # all_charges = assigns(:all_charges)
    # assert_equal 24260.7, all_charges[26][:total], "total de charges de type 26 (LOCAUX)"

    # charges = assigns(:charges)
    # assert_equal 3, charges[26].size, "Nombre de charges de type 26 (LOCAUX)"

  end

  test "synthese charges sur une période d'un mois" do
    # get :index, {exercice_id: @exercice, chantier_id: @chantier,
    #       deb_periode: {"Début(3i)"=>"1", "Début(2i)"=>"1", "Début(1i)"=>"2013"},
    #       fin_periode: {"Début(3i)"=>"31", "Début(2i)"=>"1", "Début(1i)"=>"2013"}}, 
    #   {user_id: 1}
    # assert_response :success
    # all_charges = assigns(:all_charges)
    # charges = assigns(:charges)
    # assert_equal (8207.958937691521+1.75*500), assigns(:total), "Total des charges réelles"
    # assert_equal 1.75*500, all_charges[36][36][:total], "charges de personnel"
    # assert_equal 1.75, all_charges[36][36][:total_jour], "nombre de jours de personnel"
    # assert_equal 1, charges[26].size, "Nombre de charges locaux en janvier"
  end

  test "synthese charges sur une période de 4 mois" do
    # get :index, {exercice_id: @exercice, chantier_id: @chantier,
    #       deb_periode: {"Début(3i)"=>"1", "Début(2i)"=>"1", "Début(1i)"=>"2013"},
    #       fin_periode: {"Début(3i)"=>"30", "Début(2i)"=>"4", "Début(1i)"=>"2013"}}, 
    #   {user_id: 1}
    # assert_response :success
    # all_charges = assigns(:all_charges)
    # charges = assigns(:charges)
    # assert_equal (24198.66+5.5*500), assigns(:total), "Total des charges réelles"
    # assert_equal 5.5*500, all_charges[36][:total], "charges de personnel"
    # assert_equal 2, charges[26].size, "Nombre de charges locaux en janvier - avril"
  end
end
