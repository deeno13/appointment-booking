module AvailabilitiesHelper
  def get_day_name(day_number)
    days_of_week = %w[Sunday Monday Tuesday Wednesday Thursday Friday Saturday]

    if day_number.between?(0, 6)
      return days_of_week[day_number]
    end
  end
end
