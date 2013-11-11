require 'spec_helper'

describe Item do
  describe "all categories method" do
    it 'should return a collection of all categories' do
      Item.all_categories.sort.should == ["Geography", "Math", "Science", "Social Studies"].sort
    end
  end
end
