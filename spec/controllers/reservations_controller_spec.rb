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
  describe 'changing due date of a reservation' do
    it 'should save properly' do
      reservation = Reservation.new({:user_id => 1, :item_id => 1, :quantity => 1, :date_out => Date.today, :reservation_in => Date.today + 1, :notes => nil})
      reservation.save
      put :update, {:id => reservation.id, :start_date => reservation.date_out, :end_date => (Date.today + 3).strftime("%m/%d/%Y")}
      assert Reservation.find(reservation.id).reservation_in == Date.today + 3
      reservation.destroy
    end
  end
  describe 'changing due date of a reservation causing conflict' do
    it 'should error out' do
      reservation1 = Reservation.new({:user_id => 1, :item_id => 1, :quantity => 1, :date_out => Date.today, :reservation_in => Date.today + 1, :notes => nil})
      reservation2 = Reservation.new({:user_id => 1, :item_id => 1, :quantity => 1, :reservation_out => Date.today + 2, :reservation_in => Date.today + 5, :notes => nil})
      reservation1.save
      reservation2.save
      expect { put :update, {:id => reservation1.id, :start_date => reservation1.date_out, :end_date => (Date.today + 3).strftime("%m/%d/%Y")}}.to raise_error 
      assert Reservation.find(reservation1.id).reservation_in == Date.today + 1
      reservation1.destroy
      reservation2.destroy
    end
  end
  describe 'changing due date of a reservation that was overdue' do
    it 'should save properly' do
      reservation1 = Reservation.new({:user_id => 1, :item_id => 1, :quantity => 1, :date_out => Date.today-1, :reservation_in => Date.today - 1, :notes => nil})
      reservation2 = Reservation.new({:user_id => 1, :item_id => 1, :quantity => 1, :reservation_out => Date.today + 2, :reservation_in => Date.today + 5, :notes => nil})
      reservation1.save
      reservation2.save
      put :update, {:id => reservation1.id, :start_date => reservation1.date_out, :end_date => (Date.today + 1).strftime("%m/%d/%Y")}
      assert Reservation.find(reservation1.id).reservation_in == Date.today + 1
      reservation1.destroy
      reservation2.destroy
    end
  end
  describe 'inputting invalid date' do
    it 'should error out' do
      reservation = Reservation.new({:user_id => 1, :item_id => 1, :quantity => 1, :date_out => Date.today, :reservation_in => Date.today + 1, :notes => nil})
      reservation.save
      expect { put :update, {:id => reservation.id, :start_date =>reservation.date_out, :end_date => "asdf"}}.to raise_error 
      assert Reservation.find(reservation.id).reservation_in == Date.today + 1
      reservation.destroy
    end
  end
  describe 'Canceling reservation' do
    it 'should save properly' do
      reservation = Reservation.new({:user_id => 1, :item_id => 1, :quantity => 1, :notes => nil})
      reservation.save
      request.env["HTTP_REFERER"] = "/admin/reservations"

      put :cancel, {:id => reservation.id}
      assert Reservation.find(reservation.id).canceled == true
      reservation.destroy
    end
  end
end
