class ReservationsController < ApplicationController
  respond_to :html, :json
  def index
    if params[:archived]
      @reservations = Reservation.all
      @archived = true
    else
      @reservations = Reservation.hide_archived
    end
  end

  def update
    @reservation = Reservation.find(params[:id])
    @reservation.update_attributes(params[:reservation])
    respond_with @reservation
  end  

  def checkout
    if params[:reserved]
      reservation = Reservation.find_by_id(params[:id])
      item = reservation.item
      user = reservation.user
    else
      item = Item.find_by_id(params[:item])
      reservation = Reservation.new
      user = User.find_by_email(params[:email])
      item.reservations << reservation if user
      user.reservations << reservation if user
    end
    if user
      reservation.date_out = Date.today
      reservation.save
      item.quantity -= 1
      item.save
      flash[:notice] = "Item #{item.name} was successfully checked out to #{user.name}"
    else
      flash[:warning] = "User does not exist. Please create an account for the user via the User Dashboard before checking out."
    end																		
    if params[:dashboard]
      redirect_to reservations_path
    else
      redirect_to item_path(item)
    end
  end

  def checkin
    reservation = Reservation.find_by_id(params[:id])
    reservation.date_in = Date.today
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
    reservation.archived = true
    reservation.save
    flash[:notice] = "Reservation was successfully archived"
    redirect_to reservations_path
  end

  def cancel
    reservation = Reservation.find_by_id(params[:id])
    reservation.canceled = true
    reservation.save
    flash[:notice] = "Reservation was successfully canceled"
    redirect_to users_reservations_path
  end

end
