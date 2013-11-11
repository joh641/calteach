class ReservationsController < ApplicationController
  def index
    if params[:archived]
      @reservations = Reservation.all
      @archived = true
    else
      @reservations = Reservation.hide_archived
    end
  end

  def checkout
    item = Item.find_by_id(params[:item])
    user = User.find_by_email(params[:email])
    if user
      if params[:reserved]
        reservation = Reservation.find_by_id(params[:id])
      else
        reservation = Reservation.new
      end
      reservation.status = "Checked Out"
      reservation.save
      item.quantity -= 1
      item.save
      item.reservations << reservation
      user.reservations << reservation
      flash[:notice] = "Item #{item.name} was successfully checked out to #{user.name}"
    else
      flash[:warning] = "User does not exist"
    end
    if params[:dashboard]
      redirect_to reservations_path
    else
      redirect_to item_path(item)
    end
  end
  
  def checkin
    reservation = Reservation.find_by_id(params[:id])
    reservation.status = "Checked In"
    reservation.save
    item = reservation.item
    item.quantity += 1
    item.save
    flash[:notice] = "Item #{item.name} was successfully checked in"
    if params[:dashboard]
      redirect_to reservations_path
    else
      redirect_to item_path(item)
    end
  end

  def archive
    reservation = Reservation.find_by_id(params[:id])
    reservation.status = "Archived"
    reservation.save
    redirect_to reservations_path
  end
end
