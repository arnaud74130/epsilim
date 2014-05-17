require 'test_helper'

class RecettesControllerTest < ActionController::TestCase
  setup do
    @exercice = exercices(:two)
    @chantier = chantiers(:dmp)
  end

  test "Synthese recettes" do
    # get :index, {exercice_id: @exercice, chantier_id: @chantier}, {user_id: 1}
    # assert_response :success
    # assert_equal 1597.3899999999999, assigns(:total), "Total des recettes réelles"

    # all_recettes = assigns(:all_recettes)
    # assert_equal 972.39, all_recettes[2][:total], "total de recettes de type INVESTISSEMENT"

    # recettes = assigns(:recettes)
    # assert_equal 2, recettes[2].size, "Nombre de recettes de type INVESTISSEMENT"
  end

  test "Synthese recettes sur une période de 4 mois" do
    # get :index, {exercice_id: @exercice, chantier_id: @chantier,
    #       deb_periode: {"Début(3i)"=>"1", "Début(2i)"=>"1", "Début(1i)"=>"2013"},
    #       fin_periode: {"Début(3i)"=>"30", "Début(2i)"=>"4", "Début(1i)"=>"2013"}},
    #       {user_id: 1}
    # assert_response :success
    # all_recettes = assigns(:all_recettes)
    # recettes = assigns(:recettes)
    # assert_equal 767.8578333333332, assigns(:total), "Total des recettes réelles"
    # assert_equal 125.0, all_recettes[1][:total], "recettes de personnel"
    # assert_equal 0.25, all_recettes[1][1][:total_jour], "total jours recette personnel"
    # assert_equal 2, recettes[2].size, "Nombre de recettes INVESTISSEMENT sur la zone janvier - avril"
  end

end
