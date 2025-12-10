class Coach < ApplicationRecord
  belongs_to :user
  has_many :bookings
  has_many :coach_availabilities
  has_many :reviews, through: :bookings

  validates :user_id, presence: true, uniqueness: true
  validates :specialities, presence: true
  validates :level, presence: true
  validates :location, presence: true
  validates :price_per_session, presence: true, numericality: { greater_than: 0 }
  validates :years_experience, presence: true, numericality: { greater_than_or_equal_to: 0 }

  delegate :bio, :first_name, :last_name, :photo, to: :user

  SPECIALITIES = [
    'CSO', 'Dressage', 'CCE', 'Endurance', 'Voltige', 'TREC',
    'Horse-ball', 'Attelage', 'Équitation western', 'Éthologie'
  ].freeze

  LEVEL = [
    'Débutant', 'Galop 1-2', 'Galop 3-4', 'Galop 5-6', 'Galop 7+',
    'Amateur', 'Pro', 'Compétition'
  ].freeze

  scope :verified, -> { where(verified: true) }
  scope :active, -> { where(active: true) }
  scope :by_location, ->(location) { where("location ILIKE ?", "%#{location}%") }
  scope :by_speciality, ->(speciality) { where("? = ANY(specialities)", speciality) }


  def average_rating
    reviews.average(:rating).to_f.round(1)
  end

  def total_reviews
    reviews.count
  end

  def satisfaction_rate
    return 0 if reviews.empty?

    ((reviews.where("rating >= ?", 4).count.to_f / reviews.count) * 100).round
  end

  def total_students
    bookings
      .joins(:horse)
      .select("DISTINCT horses.user_id")
      .count
  end

  def full_name
    "#{user.first_name} #{user.last_name}"
  end

  def availability_for_day(day_name)
    coach_availabilities.find { |a| a.days_off.include?(day_name) }
  end

  def available_days
    coach_availabilities.flat_map(&:days_off).uniq
  end
end
