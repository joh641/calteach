class ReservationsController < ApplicationController
  def checkout
    item = Item.find_by_id(params[:item])
    user = User.find_by_email(params[:email])
    if user
      reservation = Reservation.new
      item.quantity -= 1
      item.reservations << reservation
      item.save
      flash[:notice] = "Item #{item.name} was successfully checked out to #{user.name}"
    else
      flash[:warning] = "User does not exist"
    end
    redirect_to item_path(item)
  end
  
  def checkin
    reservation = Reservation.find_by_id(params[:id])
    item = reservation.item
    item.quantity += 1
    item.save
    flash[:notice] = "Item #{item.name} was successfully checked in"
    redirect_to item_path(item)
  end
end
