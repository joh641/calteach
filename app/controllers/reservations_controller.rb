class ReservationsController < ApplicationController
  respond_to :html, :json
  before_filter :is_admin, :only => :update

  def index
    if current_user == nil
      redirect_to "/"
    else
      @reservations = current_user.reservations
    end
  end

  def update
    @reservation = Reservation.find(params[:id])
    @reservation.update_attributes(params[:reservation])
    respond_with @reservation
  end
  
  def cancel
    reservation = Reservation.find_by_id(params[:id])
    reservation.canceled = true
    reservation.save
    flash[:notice] = "Reservation was successfully canceled"
    redirect_to reservations_path
  end

  def new
    item = Item.find_by_id(params[:format])
    start_date = params[:reservation][:start_date]
    end_date = params[:reservation][:end_date]

    quantity_desired = params[:reservation][:quantity].to_i

    if Reservation.make_reservation(current_user, item, start_date, end_date, quantity_desired)
      flash[:notice] = "Item #{item.name} was successfully reserved."
    else
      flash[:warning] = "Your reservation attempt was unsuccessful."
    end

    redirect_to item_path(item)
  end

end
