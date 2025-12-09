class Coach < ApplicationRecord
  belongs_to :user
  has_many :bookings
  has_many :coach_availabilities
end
