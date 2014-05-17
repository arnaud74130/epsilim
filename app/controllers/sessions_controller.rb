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

class SessionsController < ApplicationController
  layout 'session'
  skip_before_action :direction_cp_ro_required, only: [:login, :login_attempt, :logout]
  def login
    #   render layout: 'session'
    redirect_to exercice_chantiers_path(current_exercice) if authenticate_user
  end

  def login_attempt
    authorized_user = Personne.authenticate(params[:login_name],params[:login_password])
    if authorized_user
      session[:user_id] = authorized_user.id
      flash[:notice] = "Wow Welcome again, you logged in as #{authorized_user.username}"
      
      #----- U R L redirection  
          
      url = session[:return_to] || root_path
      session[:return_to] = nil
      url = root_path if url.eql?('/logout')
      logger.debug "URL to redirect to: #{url}"
      redirect_to(url)
    else
      flash[:notice] = "Invalid Username or Password"
      flash[:color]= "invalid"
      render "login"
    end
  end

  def logout
    session[:user_id] = nil
    redirect_to :action => 'login'
  end

end