require 'spec_helper'

describe ItemsController do
  describe 'creating a new item' do
    pending 'add tests here'
  end
  describe 'editing an item' do
    pending 'add tests here'
  end
  describe 'deleting an item' do
    pending 'add tests here'
  end
  describe 'viewing all items' do
  	it "assigns @items" do

	  	Item.create(
	  		{
	  			name: "Globe",
	  			legacy_id: "1",
	  			quantity: 5,
	  			description: "A round object you can use to view countries of the world!",
	  			category: "Science"
	  		}
	  	)

  		get :index
  		assigns(:items).should be_kind_of Array
  		expect(assigns(:items)).to eq(Item.all)
  	end
  	it "renders to :index" do
  		get :index
  		response.should render_template :index
  	end
  end
  describe 'searching for items' do
  	Item.create(
  		{
  			name: "Globe",
  			legacy_id: "1",
  			quantity: 5,
  			description: "A round object you can use to view countries of the world!",
  			category: "Science"
  		}
  	)
  	it "shows the results" do
  		get :index, :query => 'globe'
  		print assigns(:items)
  		assigns(:items).length.should == 1
  	end
  end
end
