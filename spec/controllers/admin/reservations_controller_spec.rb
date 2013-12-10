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

    it 'should have a due date before a reservation' do
      item = Item.create(:name => "Book", :quantity => 1)
      u1 = User.create!(:name => "John", :email => "jon@gmail.com", :password => 'password')
      u2 = User.create!(:name => "Bob", :email => "bob@gmail.com", :password => 'password')
      r1 = Reservation.create({:user_id => u1.id, :item_id => item.id, :reservation_out => Date.today + 2, :reservation_in => Date.today + 4, :quantity => 1})
      num_res = Reservation.all.length
      put :checkout, {:id => 3, :item => item.id, :email => "bob@gmail.com", :quantity => 1}
      r = Reservation.all.last()
      assert Reservation.all.length == num_res + 1
      assert r.date_out == Date.today
      assert r.reservation_in == r1.reservation_out - 1
      u1.delete()
      u2.delete()
      r1.delete()
      r.delete()
      item.delete()
    end

    it 'should fail if item not available' do
      item = Item.create!(:name => "Book", :quantity => 1)      
      r1 = Reservation.create({:user_id => @admin.id, :item_id => item.id, :reservation_out => Date.today, :reservation_in => Date.today + 4, :quantity => 1})
      u1 = User.create!(:name => "John", :email => "jon@gmail.com", :password => 'password')
      num_res = Reservation.all.length
      put :checkout, {:id => 3, :item => item.id, :email => "jon@gmail.com", :quantity => 1}
      assert Reservation.all.length == num_res
      item.delete()
      r1.delete()
      u1.delete()
    end

    it 'should merge with an existing reservation if checkout date falls within reservation-date range' do
      item = Item.create(:name => "Book", :quantity => 1)
      u1 = User.create!(:name => "John", :email => "jon@gmail.com", :password => 'password')
      r1 = Reservation.create!({:user_id => u1.id, :item_id => item.id, :reservation_out => Date.today - 1, :reservation_in => Date.today + 4, :quantity => 1})
      due_date = r1.item.get_due_date.business_days.after(DateTime.now).to_date
      num_res = Reservation.all.length
      put :checkout, {:id => 3, :item => item.id, :email => "jon@gmail.com", :quantity => 1}
      r1 = Reservation.find(r1.id)
      assert r1.date_out == Date.today
      assert r1.reservation_in == Date.today + 4
      assert Reservation.all.length == num_res
      item.delete()
      u1.delete()
      r1.delete()
    end

    it 'should not merge with an old reservation that has been checked in' do
      item = Item.create(:name => "Book", :quantity => 1)
      u1 = User.create!(:name => "John", :email => "jon@gmail.com", :password => 'password')
      r1 = Reservation.create!({:user_id => u1.id, :item_id => item.id, :date_out => Date.today - 5, :date_in => Date.today - 3, :quantity => 1})
      num_res = Reservation.all.length
      put :checkout, {:id => 3, :item => item.id, :email => "jon@gmail.com", :quantity => 1}
      r = Reservation.all.last()
    
      assert r1.id != r.id
      assert num_res == Reservation.all.length - 1
      item.delete()
      u1.delete()
      r1.delete()
      r.delete()
    end

    it 'should fail if reservation quantity is zero' do
      item = Item.create(:name => "Book", :quantity => 1)
      u1 = User.create!(:name => "John", :email => "jon@gmail.com", :password => 'password')
      num_res = Reservation.all.length
      put :checkout, {:id => 3, :item => item.id, :email => "jon@gmail.com", :quantity => 0}
      assert num_res == Reservation.all.length
      item.delete()
      u1.delete()
    end

    it 'should save notes properly if any exist' do
      item = Item.create(:name => "Book", :quantity => 1)
      u1 = User.create!(:name => "John", :email => "jon@gmail.com", :password => 'password')
      put :checkout, {:id => 3, :item => item.id, :email => "jon@gmail.com", :quantity => 1, :notes => "asdf"}
      assert Reservation.all.last.notes == "asdf"
      item.delete()
      u1.delete()
      Reservation.all.last.delete()
    end

    it 'should tag on the notes to the existing notes of the reservation' do
      item = Item.create(:name => "Book", :quantity => 1)
      u1 = User.create!(:name => "John", :email => "jon@gmail.com", :password => 'password')
      r1 = Reservation.create!({:user_id => u1.id, :item_id => item.id, :reservation_out => Date.today, :reservation_in => Date.today + 4, :quantity => 1, :notes => "blah."})
      put :checkout, {:id => 3, :item => item.id, :email => "jon@gmail.com", :quantity => 1, :notes => "asdf"}
      assert Reservation.find(r1.id).notes == "blah. asdf"
      item.delete()
      u1.delete()
      r1.delete()
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
