class Train < ApplicationRecord
  has_many :reservations
  validates_presence_of :number

  def available_seats
    ["1a","1b","1c","1d"]

  end

end
