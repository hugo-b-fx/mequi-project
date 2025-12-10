class FixReviewBookingReference < ActiveRecord::Migration[7.1]
  def change
    remove_reference :reviews, :bookings, foreign_key: true
    add_reference :reviews, :booking, null: false, foreign_key: true
  end
end
