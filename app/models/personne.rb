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

class Personne < ActiveRecord::Base
  default_scope {order('nom ASC')}
  #EMAIL_REGEX = /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$/i
  
  attr_accessor :password

  before_save :pretty_records
  before_save :encrypt_password
  after_save :clear_password

  belongs_to :exercice
  has_many :chantierpersonnes
  has_many :chantiers, -> { order 'chantiers.code ASC' }, through: :chantierpersonnes, dependent: :destroy
  has_many :activites, dependent: :destroy

  validates :password, :confirmation => true
  validates_length_of :password, :in => 6..20, :on => :create
  validates :username, :presence => true, :uniqueness => true, :length => { :in => 3..20 }
  #validates :email, :presence => true, :uniqueness => true, :format => EMAIL_REGEX

  ROLES = Epsilim::Application::ROLES
  ROLES.each do |role|
    define_method "is_#{role}?" do
      has_role? role
    end
  end

  def has_role? role_name
    return false unless self.roles
    return false if self.roles.empty?
    return has_roles?(role_name) if (role_name.to_s.include? ",") || role_name.is_a?(Array)
    return self.roles.split(",").include? role_name.to_s
  end

  def has_roles? role_names
    role_names=role_names.split(",") unless role_names.is_a?(Array)
    role_names.each do |role|
      return true if self.has_role? role
    end
    return false
  end

  def encrypt_password
    if password.present?
      self.salt = BCrypt::Engine.generate_salt
      self.encrypted_password= BCrypt::Engine.hash_secret(password, salt)
    end
    true
  end

  def clear_password
    self.password = nil
  end
  
  def self.authenticate(login_name="", login_password="")
    user = Personne.find_by_username(login_name)
    if user && user.match_password(login_password)
      return user
    else
      return false
    end
  end

  def match_password(login_password="")
    encrypted_password == BCrypt::Engine.hash_secret(login_password, salt)
  end

  def full_name
    nom+" "+prenom
  end

 def activites_jour_annee(jour, annee)
    jour = jour.to_i if jour.class == String
    annee = annee.to_i if annee.class == String
    self.activites.collect {|c| c if (c.jour == jour) && (c.annee == annee)}.compact
  end

 #  def chantiers_annee(annee)
 #    liste=Chantierpersonne.where(personne: self, annee: annee).inject([]) {|liste, cp| liste << cp.chantier }
 #  end

 #  def chantiers_jour_annee(jour, annee)
 #    jour = jour.to_i if jour.class == String
 #    annee = annee.to_i if annee.class == String

 #    self.activites.collect {|a| a.chantier if (a.jour == jour) && (a.annee == annee)}.compact
 #  end

  def pretty_records
    self.nom= nom.upcase
    self.prenom=prenom.titleize
    self.initiale=initiale.upcase
  end


  def suivi(opts={})

    mois = opts[:mois] || self.exercice.debut.month
    mois2 = opts[:mois2] || self.exercice.fin.month

    annee = opts[:annee] || self.exercice.debut.year
    annee2 = opts[:annee2] || self.exercice.fin.year
    suivi_mois = {}

    if (annee2>annee)
      errors.add(:exercice, "La gestion des exercices sur 2 années n'est pas encore prise en compte")
      return suivi_mois
    end

    jours=jours_inter_pour_mois_annee([mois, mois2], annee)
    if opts[:chantier_id]
      chantier=Chantier.find(opts[:chantier_id])
      suivi_mois[chantier.code] = self.activites.where(chantier: chantier, annee: annee, jour: jours).inject(0) {|sum, activite| sum+activite.poids}
    else

      self.chantiers.each do |chantier|
        suivi_mois[chantier.code] = self.activites.where(chantier: chantier, annee: annee, jour: jours).inject(0) {|sum, activite| sum+activite.poids}
      end
    end

    return suivi_mois
  end

private
  def jours_inter_pour_mois_annee(mois,annee)
    jours=Array.new
    if mois.kind_of?(Array)
      d=Date.new(annee, mois[0], 1)
      jd=d.yday
      d=Date.new(annee, mois.last, 1)
      jf=d.end_of_month.yday
      jours=[jd..jf]
    else
      d=Date.new(annee, mois, 1)
      jd=d.yday
      jf=d.end_of_month.yday
      jours=[jd..jf]
    end
    jours
  end

end