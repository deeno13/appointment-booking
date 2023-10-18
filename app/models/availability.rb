class Availability < ApplicationRecord
  belongs_to :trainer

  validates :day_of_week, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true

  validate :end_time_after_start_time


  enum day_of_week: %w[Sunday Monday Tuesday Wednesday Thursday Friday Saturday]

  private

  def end_time_after_start_time
    return if end_time.blank? || start_time.blank?

    if end_time <= start_time
      errors.add(:end_time, "must be after the start time")
    end
  end
end
