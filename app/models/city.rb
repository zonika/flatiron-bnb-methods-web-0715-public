class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, :through => :listings

  def self.highest_ratio_res_to_listings
    cities = {}
    all.each do |city|
      cities[city] = city.reservations.length.to_f/city.listings.length.to_f
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
  def city_openings(d1,d2)
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
