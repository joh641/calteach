require 'spec_helper'

describe Item do
  it 'should have many reservations' do
    pending 'reservations not yet implemented'
  end
  it 'should have many users through reservations' do
    pending 'reservations not yet implemented'
  end
  describe "all categories method" do
    it 'should return a collection of all categories' do
      Item.all_categories.sort.should == ["Geography", "Math", "Science", "Social Studies"].sort
    end
  end
end
