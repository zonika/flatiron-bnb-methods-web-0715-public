class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :rating, :description, presence:true
  validate :reservation_check

  def reservation_check
    if !reservation || reservation.status != "accepted" || Date.today < reservation.checkout
      errors.add(:reservation, "Reservation must be valid")
    end
  end
end
