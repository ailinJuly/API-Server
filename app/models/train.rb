class Train < ApplicationRecord
  mount_uploader :train_logo,TrainLogoUploader
  has_many :reservations
  validates_presence_of :number
  SEATS = begin
    (1..6).to_a.map do |series|
      ["A","B","C","D","E"].map do |letter|
        "#{series}#{letter}"
      end
    end
end
  def available_seats
      return SEATS - self.reservations.pluck(:seat_number)
  end



end
