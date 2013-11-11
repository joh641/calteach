require 'spec_helper'

describe ItemsController do
  before(:each) do
    Item.all.each do |item|
      item.destroy
    end
    Reservation.all.each do |item|
      reservation.destroy
    end
  end
  item_hash1 = {"name" => "Globe", "quantity" => "1"}
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
  	it "shows the results" do
      Item.create(
        {
          name: "Globe",
          legacy_id: "1",
          quantity: 5,
          description: "A round object you can use to view countries of the world!",
          category: "Science"
        }
      )
  		get :index, :query => 'globe'
  		assigns(:items).length.should == 1
  	end
  end
  describe 'reserves item' do
    User.create({ email: "basic@berkeley.edu", name: "Basic Bob", phone: "123-456-7890", course: "Math", category: User::BASIC, password: "password" })
    User.create({ email: "basic2@berkeley.edu", name: "Basic Bob2", phone: "123-456-7890", course: "Math", category: User::BASIC, password: "password" })
    time = Time.new
    it "successfully if no reservations exist for that item" do
      reservations_num = Reservation.all.length
      Item.create(item_hash1)
      get :reserve, :id => Item.first.id, :reservation => {start_date: "#{time.month}/#{time.day}/#{time.year + 1}", end_date: "#{time.month}/#{time.day}/#{time.year+2}"}
      expect(Reservation.all.length) == reservations_num + 1
    end
    it "successfully if reservations exist before the current reservation checkout date" do
      Item.create(item_hash1)
      Reservation.create(
        {
          :user_id => User.first.id, :item_id => Item.first.id, :reservation_out => "#{time.month}-#{time.day}-#{time.year + 1}".to_time,
          :reservation_in => "#{time.month}-#{time.day}-#{time.year + 2}".to_time
        }
      )
      reservations_num = Reservation.all.length
      get :reserve, :id => Item.first.id, :reservation => {start_date: "#{time.month}/#{time.day}/#{time.year + 3}", end_date: "#{time.month}/#{time.day}/#{time.year+4}"}
      expect(Reservation.all.length) == reservations_num + 1
    end
    it "successfully if reservations exist after the current reservation due date" do
      Item.create(item_hash1)
      Reservation.create(
        {
          :user_id => User.first.id, :item_id => Item.first.id, :reservation_out => "#{time.month}-#{time.day}-#{time.year + 4}".to_time,
          :reservation_in => "#{time.month}-#{time.day}-#{time.year + 5}".to_time
        }
      )
      reservations_num = Reservation.all.length
      get :reserve, :id => Item.first.id, :reservation => {start_date: "#{time.month}/#{time.day}/#{time.year + 1}", end_date: "#{time.month}/#{time.day}/#{time.year+2}"}
      expect(Reservation.all.length) == reservations_num + 1
    end
  end
end
