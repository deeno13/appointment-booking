class Trainer < ApplicationRecord
  has_many :appointments, dependent: :destroy
end
