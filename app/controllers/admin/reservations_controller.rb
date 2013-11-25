class Admin::ReservationsController < ApplicationController

  respond_to :html, :json
  before_filter :is_admin

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
    else
      reservation = Reservation.new
      reservation.quantity = params[:quantity].to_i
      reservation.item = Item.find_by_id(params[:item])
      reservation.user = User.find_by_email(params[:email])
    end

    checkout_helper(reservation, reservation.user)

    if params[:dashboard]
      redirect_to admin_reservations_path
    else
      redirect_to item_path(reservation.item)
    end
  end

  def checkout_helper(reservation, user)
    if user and Reservation.checkout(reservation)
      flash[:notice] = "Item #{reservation.item.name} was successfully checked out to #{reservation.user.name}"
    else  
      flash[:warning] = "Item #{reservation.item.name} could not be checked out due to an existing reservation"
      flash[:warning] = "User does not exist. Please create an account for the user via the User Dashboard before checking out." if !user
    end
  end

  def checkin
    reservation = Reservation.find_by_id(params[:id])
    reservation.date_in = Date.today
    reservation.save
    item = reservation.item
    item.save
    flash[:notice] = "Item #{item.name} was successfully checked in"
    if params[:dashboard]
      redirect_to admin_reservations_path
    else
      redirect_to item_path(item)
    end
  end

  def archive
    reservation = Reservation.find_by_id(params[:id])
    reservation.archived = true
    reservation.save
    flash[:notice] = "Reservation was successfully archived"
    redirect_to admin_reservations_path
  end

end
