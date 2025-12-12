class Horse < ApplicationRecord
  belongs_to :user
  has_many :bookings
  has_many_attached :photos


# Validations
  validates :name, presence: true
  validates :user_id, presence: true

  # Constantes pour les disciplines (cohérent avec Coach)
  DISCIPLINES = ['CSO', 'Dressage', 'CCE', 'Endurance', 'Voltige',
                 'TREC', 'Horse-ball', 'Attelage', 'Équitation western',
                 'Éthologie', 'Loisir'].freeze

  BREEDS = ['Pur-sang', 'Selle Français', 'Anglo-arabe', 'KWPN',
            'Hanovrien', 'Lusitanien', 'Pure race espagnole', 'Quarter Horse',
            'Appaloosa', 'Haflinger', 'Fjord', 'Connemara', 'Welsh',
            'Shetland', 'Poney français de selle', 'Croisé', 'Autre'].freeze

  # Scopes
  scope :by_discipline, ->(discipline) { where(discipline: discipline) }
  scope :recent, -> { order(created_at: :desc) }

  # Méthodes
  def age_display
    return "Non spécifié" if age.blank?
    "#{age} an#{'s' if age > 1}"
  end

  def primary_photo
    photos.first
  end

  def has_photos?
    photos.attached?
  end
end
