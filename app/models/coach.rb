class Coach < ApplicationRecord
  belongs_to :user
  has_many :bookings
  has_many :coach_availabilities

# Validations
  validates :user_id, presence: true, uniqueness: true
  validates :specialities, presence: true
  validates :levels, presence: true
  validates :location, presence: true
  validates :price_per_hour, presence: true, numericality: { greater_than: 0 }
  validates :years_experience, presence: true, numericality: { greater_than_or_equal_to: 0 }

  # Enums pour les spécialités (basé sur les maquettes)
  SPECIALITIES = ['CSO', 'Dressage', 'CCE', 'Endurance', 'Voltige', 'TREC',
                  'Horse-ball', 'Attelage', 'Équitation western', 'Éthologie'].freeze

  LEVELS = ['Débutant', 'Galop 1-2', 'Galop 3-4', 'Galop 5-6', 'Galop 7+',
            'Amateur', 'Pro', 'Compétition'].freeze

  # Méthodes pour gérer les arrays (PostgreSQL)
  

  # Scopes utiles
  scope :verified, -> { where(verified: true) }
  scope :active, -> { where(active: true) }
  scope :by_location, ->(location) { where("location ILIKE ?", "%#{location}%") }
  scope :by_speciality, ->(speciality) { where("? = ANY(specialities)", speciality) }

  # Méthodes calculées
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
    bookings.where(status: 'completed').select(:user_id).distinct.count
  end

  def full_name
    "#{user.first_name} #{user.last_name}"
  end

  def availability_for_day(day_name)
    coach_availabilities.where("? = ANY(days_off)", day_name).first
  end

  def available_days
    coach_availabilities.map { |a| a.days_off }.flatten.uniq
  end

end
