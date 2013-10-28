require 'spec_helper'

describe ItemsController do
  item_hash1 = {"name" => "Globe", "quantity" => "2"}
  describe 'POST #create' do
    it 'should create a new item using the params passed in' do
    	post :create, :item => item_hash1
    	Item.first.name.should == item_hash1["name"]
    	Item.first.quantity.to_s.should == item_hash1["quantity"]
    end
  end
  describe 'GET #show' do
    it 'should retrieve an item using the id passed in' do
    	i1 = Item.create!(item_hash1)
    	get :edit, :id => Item.first
    	assigns(:item).should eq(i1)
    end
  end
  describe 'DELETE #destroy' do
    it 'should destroy an item with the id passed in' do
    	i1 = Item.create!(item_hash1)
    	delete :destroy, :id => Item.first
    	Item.all.length.should == 0
    end
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
