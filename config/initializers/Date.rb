require 'date'

class Date
 def is_weekend?
    self.wday == 6 || self.wday == 0
  end

  def is_weekday?
    !self.is_weekend?
  end

  def week_number
    self.strftime("%W").to_i % 52 + 1
  end

  def week
    Array.new(7) { |offset| self.at_beginning_of_week + offset.days }
  end

  def weeks_of_month
    weeks = Array.new
    next_month = (self + 1.month).month
    current_day = self.at_beginning_of_month.at_beginning_of_week
    while current_day.month != next_month
      weeks << current_day.week
      current_day += 7.days
    end
    weeks
  end

  def to_fr
    self.strftime('%d/%m/%Y')
  end

  def self.date_from_yday(year_yday) #ex: date_from_yday("2013-133") =>
    Date.strptime(year_yday, "%Y-%j")
  end

  def self.from_fr_string(chaine)
    Date.strptime(chaine, "%d/%m/%Y")
  end  
  def self.periode_string_to_ydays_years(debut,fin)
    debut=Date.from_fr_string(debut)
    fin=Date.from_fr_string(fin)
    yday1=debut.yday
    annee1=debut.year
    yday2=fin.yday
    annee2=fin.year
    return yday1, annee1, yday2, annee2
  end
end
