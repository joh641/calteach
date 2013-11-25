class ReservationsController < ApplicationController
  respond_to :html, :json

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
    if start_date and end_date
      start_date = Date.strptime(start_date, "%m/%d/%Y")
      end_date = Date.strptime(end_date, "%m/%d/%Y")
    else
      start_date = nil
      end_date = nil
    end

    quantity_desired = params[:reservation][:quantity].to_i

    if Reservation.valid_reservation?(start_date, end_date, item, quantity_desired)
      Reservation.create({:user_id => current_user.id, :item_id => item.id, :reservation_out => start_date, :reservation_in => end_date, :quantity => quantity_desired})
      flash[:notice] = "Item #{item.name} was successfully reserved."
    else
      flash[:warning] = "Your reservation attempt was unsuccessful."
    end

    redirect_to item_path(item)
  end

end
