class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :messages, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :coaches, dependent: :destroy
  has_many :horses, dependent: :destroy
  has_many :chats, dependent: :destroy
  has_many :coach_chats, class_name: "Chat", foreign_key: "coach_id"

  def full_name
    "#{first_name} #{last_name}".strip
  end

  def coach?
    role == "coach"
  end

  def rider?
    role == "rider"
  end
end
