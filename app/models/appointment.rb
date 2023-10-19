class Appointment < ApplicationRecord
  belongs_to :trainer

  validates :start_time, presence: true
  validates :end_time, presence: true

  validate :start_time_cannot_be_in_the_past
  validate :end_time_after_start_time

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
end
