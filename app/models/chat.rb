class Chat < ApplicationRecord
  belongs_to :user
  belongs_to :coach, optional: true
  has_many :messages, dependent: :destroy

  validates :user_id, uniqueness: true
end
