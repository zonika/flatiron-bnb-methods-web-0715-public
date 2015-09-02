class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  validates :address, :listing_type, :title, :description, :price, :neighborhood, presence:true

  after_create :makehost
  after_destroy :destroyhost

  def average_review_rating
    reviews.average(:rating).to_f
  end

  private
  def makehost
    host.host = true
    host.save
  end
  def destroyhost
    if host.listings.length == 0
      host.host = false
    end
    host.save
  end
end
