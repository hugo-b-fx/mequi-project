class Chat < ApplicationRecord
  belongs_to :user
  belongs_to :coach, class_name: "User"
  has_many :messages
end
