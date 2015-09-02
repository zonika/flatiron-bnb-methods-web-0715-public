class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, :checkout, presence:true
  validate :same_ids, :checkin_before_checkout, :same_checkout_checkin, :checkin_checkout

  def same_ids
    if guest == listing.host
      errors.add(:guest, "Cannot be the host and the guest")
    end
  end

  def checkin_before_checkout
    if checkin && checkout
      if duration < 0
        errors.add(:checkout, "Checkin must be before checkout")
      end
    end
  end
  def same_checkout_checkin
    if checkin && checkout
      if duration == 0
        errors.add(:checkout, "Must stay for at least one day")
      end
    end
  end
  def checkin_checkout
    if checkin && checkout
      listing.reservations.each do |reservation|
        if reservation.checkout > checkin && reservation.checkin < checkout
          errors.add(:checkout, "Listing is taken during that time")
        end
      end
    end
  end

  def duration
    (checkout - checkin).to_i
  end

  def total_price
    listing.price * duration
  end
end
