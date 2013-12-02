class ReservationsController < ApplicationController
  respond_to :html, :json
  before_filter :is_admin_or_owner, :only => [:update, :cancel]

  def index
    if not current_user
      redirect_to items_path
    else
      @reservations = current_user.reservations
    end
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

  def update
    date = params[:reservation][:reservation_in]
    if date.is_a?(String)
      params[:reservation][:reservation_in] = date != "" ? Date.strptime(date, "%m/%d/%Y") : nil
      start_date = reservation.date_out ? reservation.date_out : reservation.reservation_out
      raise "Conflicting Date Error" unless Reservation.valid_reservation?(start_date, params[:reservation][:reservation_in], Item.find_by_id(reservation.item_id), reservation.quantity, reservation)
    end
    reservation.update_attributes(params[:reservation])
    respond_with reservation
  end

  def cancel
    reservation.cancel
    redirect_to reservations_path, notice: "Reservation was successfully canceled."
  end

  private

  def reservation
    @reservation = Reservation.find(params[:id])
  end

  def is_admin_or_owner
    if current_user && (current_user.admin? || current_user == reservation.user)
      return true
    else
      flash[:error] = "Error: Not owner or admin"
      redirect_to root_path
    end
  end

end
