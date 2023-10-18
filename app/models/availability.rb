class Availability < ApplicationRecord
  belongs_to :trainer

  validates :day_of_week, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true

  enum day_of_week: %w[Sunday Monday Tuesday Wednesday Thursday Friday Saturday]
end
