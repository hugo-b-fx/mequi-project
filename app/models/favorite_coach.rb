class FavoriteCoach < ApplicationRecord
  belongs_to :user
  belongs_to :coach

  validates :user_id, uniqueness: { scope: :coach_id, message: "Coach déjà dans vos favoris" }
end
