require 'spec_helper'

describe ItemsController do
  before(:each) do
    request.env["device.mapping"] = Devise.mappings[:user] 
    @admin = User.create(:name => 'Test Admin', :email => 'admin@email.com', :phone => '1234567890', :category => User::ADMIN, :password => "password")
    @admin.confirmed_at = Time.zone.now
    @admin.save
    sign_in @admin

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
      delete :destroy, :id => i1.id
      Item.find(i1.id).inactive.should eq(true)
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

end
