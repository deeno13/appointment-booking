class Appointment < ApplicationRecord
  belongs_to :trainer

  validates :start_time, presence: true
  validates :end_time, presence: true

  validate :time_constraints

  scope :overlapping, ->(start_time, end_time) {
    where('(? <= end_time) AND (? >= start_time)', end_time, start_time)
  }

  private

  # Even though I limited the datetime picker to only allow future dates and times,
  # I still want to make sure that the times can't be bypassed by manually entering a date and time
  def time_constraints
    return if end_time.blank? || start_time.blank?

    # Start time cannot be in the past
    errors.add(:start_time, "cannot be in the past") if start_time_in_the_past?

    # Make sure the end time is after the start time
    errors.add(:end_time, "must be after the start time") if end_time_after_start_time?

    # Make sure the appointment does not overlap with an existing appointment
    errors.add(:base, "Appointment slot is already taken") if overlapping_appointment?

    # Make sure the appointment is within the trainer's availability
    errors.add(:base, "Time must be within trainer availability") if not_within_trainer_availability?
  end

  def start_time_in_the_past?
    start_time < Time.now
  end

  def end_time_after_start_time?
    end_time <= start_time
  end

  def overlapping_appointment?
    # Don't take into account current appointment
    existing_appointments = trainer.appointments.where.not(id: id)
    overlapping_appointments = existing_appointments.overlapping(start_time, end_time)

    overlapping_appointments.exists?
  end

  def not_within_trainer_availability?
    availability = trainer.availabilities.where(day_of_week: start_time.wday).first
    availability_start_time = availability.start_time.strftime('%H:%M:%S')
    availability_end_time = availability.end_time.strftime('%H:%M:%S')

    appointment_start_time = start_time.strftime('%H:%M:%S')
    appointment_end_time = end_time.strftime('%H:%M:%S')

    appointment_start_time < availability_start_time || appointment_end_time > availability_end_time
  end
end
