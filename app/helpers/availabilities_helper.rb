module AvailabilitiesHelper

  # Since day_of_week is an integer, we need to convert it to day name for readability
  def get_day_name(day_number)
    days_of_week = %w[Sunday Monday Tuesday Wednesday Thursday Friday Saturday]

    if day_number.between?(0, 6)
      return days_of_week[day_number]
    end
  end

  def availability_slots(trainer, appointment, date)
    availability_slots = {}

    # Get all the availabilities for the trainer
    trainer.availabilities.each do |availability|
      day_of_week = availability.day_of_week

      # Initialize the availability_slots hash with the day_of_week as the key
      # and an empty hash as the value if it is not already initialized
      availability_slots[day_of_week] ||= {}

      # Loop through the availability start time and end time and add them in 1 hour intervals
      # to the availability_slots hash with the status of :available
      current_time = availability.start_time
      while current_time < availability.end_time
        availability_slots[day_of_week][current_time.strftime('%I:%M %p')] = :available
        current_time += 1.hour
      end
    end

    # Get all the appointments for the trainer where the date matches the date param
    trainer.appointments.where('DATE(start_time) = ?', Date.parse(date)).each do |existing_appointment|
      # Skip the appointment if the start_time is not set (can't figure out why this is happening)
      next unless existing_appointment.start_time

      day_of_week = existing_appointment.start_time.wday

      availability_slots[day_of_week] ||= {}

      # Loop through the appointment start time and end time and add them in 1 hour intervals
      # to the availability_slots hash with the status of :unavailable
      current_time = existing_appointment.start_time
      while current_time < existing_appointment.end_time
        unless existing_appointment.id == appointment&.id && current_time >= appointment.start_time && current_time < appointment.end_time
          availability_slots[day_of_week][current_time.strftime('%I:%M %p')] = :unavailable
        end
        current_time += 1.hour
      end
    end

    # Get the day integer for the date param
    day = Date::DAYNAMES[@wday]

    # Set the hourly intervals for the day to an empty hash if there are no availabilities and appointments
    hourly_intervals = availability_slots[@wday] || {}
    slots_list = ''

    # Set availabilities as green and unavailabilities as red
    hourly_intervals.each do |time, status|
      if status == :available
        slots_list += "<li class='w-full border border-green-200 rounded bg-green-100 py-2 px-3 text-center my-2'>#{time}</li>"
      else
        slots_list += "<li class='w-full border border-red-200 rounded bg-red-100 py-2 px-3 text-center my-2'>#{time}</li>"
      end
    end

    # Return the day name and the final list of slots
    return "
      <p>#{day}</p>
      <div class='flex flex-row h-[400px] mt-2'>
        <ul class='w-full overflow-y-auto'>
          #{slots_list}
        </ul>
      </div>
    ".html_safe
  end
end
