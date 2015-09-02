class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings
  has_many :reservations, through: :listings

  def self.highest_ratio_res_to_listings
    cities = {}
    all.each do |city|
      rat = city.reservations.length.to_f/city.listings.length.to_f
      if city.listings.length.to_f == 0
        rat = 0
      else
        rat = city.reservations.length.to_f/city.listings.length.to_f
      end
      cities[city] = rat
    end
    cities.max_by{|k,v| v}[0]
  end

  def self.most_res
    cities = {}
    all.each do |city|
      cities[city] = city.reservations.length
    end
    cities.max_by{|k,v| v}[0]
  end

  def neighborhood_openings(d1,d2)
    openings = []
    d1 = Date.parse(d1)
    d2 = Date.parse(d2)
    listings.each do |listing|
      listing.reservations.each do |reservation|
        if reservation.checkout < d1 || reservation.checkin > d2
          openings << listing
        end
      end
    end
    openings
  end
end
