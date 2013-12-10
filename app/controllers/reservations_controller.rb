class ReservationsController < ApplicationController
  respond_to :html, :json
  before_filter :is_admin_or_owner, :only => [:update, :cancel]

  def index
    if not current_user
      redirect_to items_path
    else
      @reservations = current_user.reservations.where(:canceled =>false)
    end
  end

  def new
    item = Item.find_by_id(params[:format])
    begin
      Reservation.make_reservation(current_user, item, params[:reservation][:start_date], params[:reservation][:end_date], params[:reservation][:quantity].to_i)
      flash[:notice] = "Item #{item.name} was successfully reserved."
    rescue => e
      flash[:warning] = "Reservation attempt was unsuccessful because" + e.message
    end
    redirect_to item_path(item)
  end

  def update
    start_date = Reservation.strip_date(params[:start_date])
    end_date = Reservation.strip_date(params[:end_date])
    reservation = Reservation.find(params[:id])

    if start_date and end_date
      params[:reservation] = check_dates(start_date, end_date, reservation, params[:reservation])
      check_valid_reservation(start_date, end_date, reservation)
    end
    make_updates(reservation, params)
  end

  def cancel
    reservation.cancel
    redirect_to :back, notice: "Reservation was successfully canceled."
  end

  private

  def make_updates(reservation, params)
    reservation.update_attributes(params[:reservation])

    get_response(reservation, params[:return_address])
  end

  def get_response(reservation, return_address)
    if return_address
      respond_with reservation, :location => return_address
    else
      respond_with reservation
    end
  end

  def check_dates(start_date, end_date, reservation, res_params)
    begin
      update_params(reservation, res_params, start_date, end_date)
    rescue
      raise "Invalid Date"
    end
  end

  def check_valid_reservation(start_date, end_date, reservation)
    if not Reservation.valid_reservation?(start_date, end_date, reservation.item, reservation.quantity, reservation, is_admin)
      raise "Conflicting Reservation"
    end
  end

  def update_params(reservation, res_params, start_date, end_date)
    res_params ||= Hash.new

    if reservation.checked_out?
      res_params[:date_out] = start_date
    else
      res_params[:reservation_out] = start_date
    end
    res_params[:reservation_in] = end_date

    res_params
  end

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
