class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :messages, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :coaches, dependent: :destroy
  has_many :horses, dependent: :destroy
  has_many :chats, dependent: :destroy
  has_many :coach_chats, class_name: "Chat", foreign_key: "coach_id"
  has_one :chat, dependent: :destroy
  has_one_attached :photo

 #Association avec les bookings (en tant que cavalier)
  has_many :bookings, dependent: :destroy
  has_many :booked_coaches, through: :bookings, source: :coach

 # Validations
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :role, inclusion: { in: ["coach", "rider"] }

  # Enums ou constantes
  ROLES = ["coach", "rider"].freeze

  # Scopes
  scope :riders, -> { where(role: "rider") }
  scope :coaches_only, -> { where(role: "coach") }

  def full_name
    "#{first_name} #{last_name}".strip
  end

  def coach?
    role == "coach"
  end

  def rider?
    role == "rider"
  end

 # Statistiques cavalier
  def total_lessons
    bookings.where(status: 'completed').count
  end

  def total_hours_trained
    bookings.where(status: 'completed').sum do |booking|
      ((booking.end_at - booking.start_at) / 3600.0).round(1)
    end
  end

  def favorite_discipline
    horses.group(:discipline).count.max_by { |_, count| count }&.first || "Non spécifié"
  end

  def completed_bookings
    bookings.where(status: 'completed').order(start_at: :desc)
  end

  def upcoming_bookings
    bookings.where(status: 'pending')
             .where('start_at > ?', Time.current)
             .order(start_at: :asc)
  end

  # Méthode pour accepter les attributs imbriqués des chevaux
  accepts_nested_attributes_for :horses,
                                allow_destroy: true,
                                reject_if: :all_blank

end
