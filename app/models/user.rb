class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :messages  #, :reviews, :coaches, :horses, :chats
  has_many :reviews
  has_many :coaches
  has_many :horses
  has_many :chats
  has_many :coach_chats, class_name: "Chats", foreign_key: "coach_id"
end
