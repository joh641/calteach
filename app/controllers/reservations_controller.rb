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

    begin
      Reservation.make_reservation(current_user, item, start_date, end_date, quantity_desired)
      flash[:notice] = "Item #{item.name} was successfully reserved."
    rescue => e
      flash[:warning] = "Reservation attempt was unsuccessful because" + e.message
    end
    redirect_to item_path(item)
  end

  def update
    start_date = params[:start_date]
    end_date = params[:end_date]
    if start_date and end_date
      begin
        start_date = Reservation.strip_date(start_date)
        end_date = Reservation.strip_date(end_date)

        params[:reservation] = update_params(reservation, params[:reservation], start_date, end_date)
      rescue
        raise "Invalid Date"
      end

      if !Reservation.valid_reservation?(start_date, end_date, reservation.item, reservation.quantity, reservation, is_admin)
        raise "Conflicting Reservation"
      end
    end

    reservation.update_attributes(params[:reservation])

    if params[:return_address]
      respond_with reservation, :location => params[:return_address]
    else
      respond_with reservation
    end
  end

  def cancel
    reservation.cancel
    redirect_to :back, notice: "Reservation was successfully canceled."
  end

  private

  # def format_dates(start_date, end_date)
  #   start_date = start_date != "" ? Reservation.strip_date(start_date) : nil
  #   end_date = end_date != "" ? Reservation.strip_date(end_date) : nil
  # end

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
