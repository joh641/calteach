require 'spec_helper'

describe ReservationsController do
  before :each do
    request.env["device.mapping"] = Devise.mappings[:user]
    @admin = User.create(:name => 'Test Admin', :email => 'admin@email.com', :phone => '1234567890', :category => User::ADMIN, :password => "password")
    @admin.confirmed_at = Time.zone.now
    @admin.save
    sign_in @admin
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
