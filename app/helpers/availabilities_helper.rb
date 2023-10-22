module AvailabilitiesHelper
  def get_day_name(day_number)
    days_of_week = %w[Sunday Monday Tuesday Wednesday Thursday Friday Saturday]

    if day_number.between?(0, 6)
      return days_of_week[day_number]
    end
  end

  def availability_slots(t, a, d)
    availability_slots = {}

    t.availabilities.each do |availability|
      day_of_week = availability.day_of_week

      availability_slots[day_of_week] ||= {}

      current_time = availability.start_time
      while current_time < availability.end_time
        availability_slots[day_of_week][current_time.strftime('%I:%M %p')] = :available
        current_time += 1.hour
      end
    end

    t.appointments.where('DATE(start_time) = ?', Date.parse(d)).each do |appointment|
      next unless appointment.start_time

      day_of_week = appointment.start_time.wday

      availability_slots[day_of_week] ||= {}

      current_time = appointment.start_time
      while current_time < appointment.end_time
        unless appointment.id == a&.id && current_time >= a.start_time && current_time < a.end_time
          availability_slots[day_of_week][current_time.strftime('%I:%M %p')] = :unavailable
        end
        current_time += 1.hour
      end
    end

    day = Date::DAYNAMES[@wday]
    hourly_intervals = availability_slots[@wday] || {}
    final_slots = ''
    hourly_intervals.each do |time, status|
      if status == :available
        final_slots += "<li class='w-full border border-green-200 rounded bg-green-100 py-2 px-3 text-center my-2'>#{time}</li>"
      else
        final_slots += "<li class='w-full border border-red-200 rounded bg-red-100 py-2 px-3 text-center my-2'>#{time}</li>"
      end
    end

    return "
      <p>#{day}</p>
      <div class='flex flex-row h-[400px] mt-2'>
        <ul class='w-full overflow-y-auto'>#{final_slots}</ul>
      </div>
    ".html_safe
  end
end
