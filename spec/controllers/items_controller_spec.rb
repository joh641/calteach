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
end
