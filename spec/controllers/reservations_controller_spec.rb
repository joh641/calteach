require 'spec_helper'

describe ReservationsController do
  before :each do
    @item = Item.create(:name => "Globe", :quantity => 1)
    @reservation = Reservation.create
    @user = User.create(:name => "Test", :email => "test@test.com")
    @reservation.item = @item
    @reservation.user = @user
  end
  describe 'index archive removed' do
    it 'should show archived reservations if archive selected' do
      get :index, {:archived => true}
    end
    it 'should not show archived reservations otherwise' do
      get :index
    end
  end
  describe 'checking out an item' do
    it 'should redirect to the index if done from dashboard' do
      put :checkout, {:id => @reservation.id, :reserved => true, :dashboard => true}
      response.should redirect_to(reservations_path)      
    end
  end
  describe 'archiving a reservation' do
    it 'should redirect to the index' do
      @reservation.status = 'Checked In'
      @reservation.save
      put :archive, {:id => @reservation.id}
      response.should redirect_to(reservations_path)
    end
  end
  describe 'adding comments to a reservation' do
    it 'should save properly' do
      reservation = Reservation.new({:user_id => 1, :item_id => 1, :quantity => 1, :notes => nil})
      reservation.save
      put :update, {:id => reservation.id, :reservation => {:notes => "Testing Notes"}}
      assert Reservation.find(reservation.id).notes == "Testing Notes"
      reservation.destroy
    end
  end
  describe 'Canceling reservation' do
    it 'should save properly' do
      reservation = Reservation.new({:user_id => 1, :item_id => 1, :quantity => 1, :notes => nil})
      reservation.save
      put :cancel, {:id => reservation.id}
      assert Reservation.find(reservation.id).canceled == true
      reservation.destroy
    end
  end
end
