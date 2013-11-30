require 'spec_helper'

describe Admin::ReservationsController, :type => :controller  do
  before :each do
    @item = Item.create(:name => "Globe", :quantity => 1)
    @reservation = Reservation.create
    @user = User.create(:name => "Test", :email => "test@test.com")
    @reservation.item = @item
    @reservation.user = @user
    @reservation.save

    request.env["devise.mapping"] = Devise.mappings[:user]
    @admin = User.create!(:name => 'Test Admin', :email => 'admin@email.com', :phone => '1234567890', :category => User::ADMIN, :password => 'password')
    @admin.confirmed_at = Time.zone.now
    @admin.save
    sign_in @admin
    request.env["HTTP_REFERER"] = "/admin/reservations"
  end
  describe 'checking out an item' do
    it 'should redirect to the index if done from dashboard' do
      put :checkout, {:id => @reservation.id, :reserved => true}
      response.should redirect_to(admin_reservations_path)
    end
  end
  # describe 'archiving a reservation' do
  #   it 'should redirect to the index if done from dashboard' do
  #     @reservation.archived = true
  #     @reservation.save
  #     put :archive, {:id => @reservation.id}
  #     response.should redirect_to(admin_reservations_path)
  #   end
  # end
end
