class Coach < ApplicationRecord
  include PgSearch::Model

  belongs_to :user
  has_many :bookings, dependent: :destroy
  has_many :coach_availabilities, dependent: :destroy
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

  pg_search_scope :search_by_text,
    against: [:specialities, :location, :level],
    associated_against: {
      user: [:first_name, :last_name, :bio]
    },
    using: {
      tsearch: { prefix: true, dictionary: "french" }
    },
    ignoring: :accents

  scope :by_location, ->(location) { where("location ILIKE ?", "%#{location}%") }
  scope :by_speciality, ->(speciality) { where("specialities ILIKE ?", "%#{speciality}%") }
  scope :by_price_range, ->(min, max) {
    scope = all
    scope = scope.where("price_per_session >= ?", min) if min.present?
    scope = scope.where("price_per_session <= ?", max) if max.present?
    scope
  }
  scope :by_level, ->(level) { where(level: level) }
  scope :by_experience, ->(min_years) { where("years_experience >= ?", min_years) }
  scope :with_availability, -> {
    joins(:coach_availabilities).distinct
  }

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
    bookings.joins(:horse).select("DISTINCT horses.user_id").count
  end

  def full_name
    "#{user.first_name} #{user.last_name}"
  end

  def specialities_list
    specialities.to_s.split(",").map(&:strip)
  end

  def availability_for_day(day_name)
    coach_availabilities.find { |a| a.days_off.include?(day_name) }
  end

  def available_days
    coach_availabilities.flat_map(&:days_off).uniq
  end

  def available_slots(date)
  # 1. Trouver la disponibilité correspondant au jour
    weekday = date.strftime("%A").downcase
    availability = coach_availabilities.find_by(days_off: weekday)

    return [] unless availability

    # 2. Générer tous les créneaux horaires d’une durée fixe (1h ici)
    slots = []
    start_time = availability.start_time
    end_time   = availability.end_time

  # On convertit pour coller la date sélectionnée
    start_dt = DateTime.new(date.year, date.month, date.day, start_time.hour, start_time.min)
    end_dt   = DateTime.new(date.year, date.month, date.day, end_time.hour, end_time.min)

    current = start_dt

    while current < end_dt
      slot_end = current + 1.hour
      slots << { start_at: current, end_at: slot_end }
      current = slot_end
    end

  # 3. Filtrer les créneaux déjà pris
    booked = bookings.where("DATE(start_at) = ?", date)

    slots.reject do |slot|
      booked.any? do |b|
        slot[:start_at] < b.end_at && slot[:end_at] > b.start_at
      end
    end
  end
end
