require 'spec_helper'

describe Reservation do
  describe "hiding archived reservations" do
    it "should hide reservations that have been archived" do
      start_date = Date.today
      end_date = Date.today + 1
      archived = Reservation.new
      archived.archived = true
      archived.save
      Reservation.create(:reservation_out => start_date, :reservation_in => end_date)
      Reservation.create(:reservation_out => start_date, :reservation_in => end_date, :date_out => start_date)
      Reservation.hide_archived.length.should == 2
    end
  end
end
