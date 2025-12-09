class Booking < ApplicationRecord
  belongs_to :horse
  belongs_to :coach
  has_many :reviews
end
