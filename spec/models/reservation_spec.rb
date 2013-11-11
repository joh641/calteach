require 'spec_helper'

describe Reservation do
  describe "hiding archived reservations" do
    it "should hide reservations that have been archived" do
      Reservation.create(:status => 'Archived')
      Reservation.create(:status => 'Reserved')
      Reservation.create(:status => 'Checked Out')
      Reservation.hide_archived.length.should == 2
    end
  end
end
