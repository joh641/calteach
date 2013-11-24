class ReservationsController < ApplicationController
  respond_to :html, :json

  def index
    if current_user == nil or !current_user.admin?
      redirect_to "/"
    end
    @reservations = current_user.reservations
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
    if params[:reservation][:start_date] != "" and params[:reservation][:end_date] != ""
      start_date = params[:reservation][:start_date] != "" ? Date.strptime(params[:reservation][:start_date], "%m/%d/%Y") : nil
      end_date = params[:reservation][:end_date] != "" ? Date.strptime(params[:reservation][:end_date], "%m/%d/%Y") : nil
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

  def edit
    if current_user == nil or !current_user.admin?
      redirect_to "/"
    end
    @reservation = Reservation.find_by_id(params[:id])
  end

  def update
    @reservation = Reservation.find_by_id(params[:id])
    @reservation.update_attributes(params[:reservation])
    flash[:notice] = "Reservation #{@reservation.id} was successfully updated."
    redirect_to admin_reservations_path
  end

  def show
    @reservation = Reservation.find_by_id(params[:id])
  end
end
