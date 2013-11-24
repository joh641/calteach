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
      item = reservation.item
      user = reservation.user
    else
      reservation = Reservation.new
      item = Item.find_by_id(params[:item])
      user = User.find_by_email(params[:email])
    end
   
    if user
      checkout_date = Date.today
      due_date = item.get_due_date.business_days.after(DateTime.now).to_date
      number_available = item.quantity_available

      if !params[:reserved]
        desired_quantity = params[:quantity].to_i
        if number_available >= desired_quantity
          item.reservations << reservation
          user.reservations << reservation
          reservation.quantity = desired_quantity
        else
          flash[:warning] = "Item #{item.name} could not be checked out due to an existing reservation"
          redirect_to item_path(item) and return
        end
      else
        if number_available < reservation.quantity
          flash[:warning] = "Item #{item.name} could not be checked out due to an existing reservation"
          redirect_to admin_reservations_path and return
        end
      end
  
      reservation.reservation_out = checkout_date
      reservation.reservation_in = due_date
      reservation.date_out = checkout_date
      reservation.save
      item.save
      flash[:notice] = "Item #{item.name} was successfully checked out to #{user.name}"
  
    else
      flash[:warning] = "User does not exist. Please create an account for the user via the User Dashboard before checking out."
    end

    if params[:dashboard]
      redirect_to admin_reservations_path
    else
      redirect_to item_path(item)
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
