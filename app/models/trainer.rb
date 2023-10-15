class Trainer < ApplicationRecord
  has_many :appointments, dependent: :destroy
  has_many :availabilities, dependent: :destroy
end
