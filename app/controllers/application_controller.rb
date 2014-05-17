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

class ApplicationController < ActionController::Base
  before_action :direction_cp_ro_required
  before_action :read_only_interception
  
  helper :html
  helper_method :current_user, :current_exercice
  
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  #   protect_from_forgery with: :exception

  #
  # ----------------- R O L E S -----------------
  #

  # -- methods helper, admin_required, compta_required, and all permutations admin_compta...
  role_methods = Epsilim::Application::ROLE_METHODS

  role_methods.each do |role|
    define_method "#{role}_required" do
      role_required role.split("_")
    end
  end

  def role_access_denied
    flash[:notice] = "Vous n'avez pas l'autorisation requise."
    redirect_to login_path
  end
  # -- méthodes spécifiques
  def cp_id
    role_access_denied if current_user.is_cp? && current_user.id!=params[:id].to_i      
  end
  # ---------------------------------------------
def read_only_interception
 if @current_user && params[:action] && current_user.is_ro?
    if params[:action]=="new" || params[:action]=="edit" ||  params[:action]=="update" ||  params[:action]=="create" || params[:action] == "destroy"
      role_access_denied
    end
 end
end
  def current_user
    @current_user ||= Personne.find(session[:user_id])
  end

  def current_exercice
    @exercice ||= Exercice.find(@current_user.exercice_id) if current_user
  end

  def authenticate_user
    if session[:user_id]
      @current_user = Personne.find session[:user_id]
      return true
    else
      session[:return_to] = request.url
      return false
    end
  end

  private
  def role_required role
    role_access_denied unless authenticate_user && @current_user.has_role?(role)
  end


end