class Availability < ApplicationRecord
  belongs_to :trainer

  validates :day_of_week, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true

  validate :time_constraints

  private

  def time_constraints
    return if end_time.blank? || start_time.blank?

    # Make sure the end time is after the start time
    errors.add(:end_time, "must be after the start time") if end_time_after_start_time?

    # Make sure the availability is at least 1 hour long
    errors.add(:base, "Availability must be at least 1 hour long") if less_than_1_hour?
  end

  def end_time_after_start_time?
    end_time <= start_time
  end

  def less_than_1_hour?
    (end_time - start_time) < 1.hour
  end
end
