class Appointment < ApplicationRecord
  belongs_to :trainer

  validates :start_time, presence: true
  validates :end_time, presence: true

  validate :start_time_cannot_be_in_the_past
  validate :end_time_after_start_time
  validate :no_overlapping_appointments
  validate :within_trainer_availability

  private

  def start_time_cannot_be_in_the_past
    errors.add(:start_time, "cannot be in the past") if start_time.present? && start_time < Time.now
  end

  def end_time_after_start_time
    return if end_time.blank? || start_time.blank?

    if end_time <= start_time
      errors.add(:end_time, "must be after the start time")
    end
  end

  def no_overlapping_appointments
    return if end_time.blank? || start_time.blank?
    if trainer && overlaps_with_existing_appointment?
      errors.add(:base, 'Appointment slot is already taken')
    end
  end

  def overlaps_with_existing_appointment?
    existing_appointments = trainer.appointments.where.not(id: id)
    overlapping_appointments = existing_appointments.where(
      '(? <= end_time) AND (? >= start_time)',
      end_time,
      start_time
    )

    overlapping_appointments.exists?
  end

  def within_trainer_availability
    return if end_time.blank? || start_time.blank?

    availables = trainer.availabilities.where(day_of_week: start_time.wday)

    start_time_only = start_time.strftime('%H:%M:%S')
    end_time_only = end_time.strftime('%H:%M:%S')

    if availables.empty?
      errors.add(:base, "Trainer is not available on that day")
    else
      if start_time_only < availables.first.start_time.strftime('%H:%M:%S')
        errors.add(:start_time, "must be within trainer's availability")
      end

      if end_time_only > availables.first.end_time.strftime('%H:%M:%S')
        errors.add(:end_time, "must be within trainer's availability")
      end
    end
  end
end
