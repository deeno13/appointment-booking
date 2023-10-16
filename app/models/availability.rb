class Availability < ApplicationRecord
  belongs_to :trainer

  enum day_of_week: %w[Monday Tuesday Wednesday Thursday Friday Saturday Sunday]
end
