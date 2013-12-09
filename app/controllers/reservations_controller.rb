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
    start_date = params[:start_date]
    end_date = params[:end_date]
    if start_date and end_date
      begin
        start_date = start_date != "" ? Date.strptime(start_date, "%m/%d/%Y") : nil
        end_date = end_date != "" ? Date.strptime(end_date, "%m/%d/%Y") : nil
        params[:reservation] = Hash.new if !params[:reservation]

        if reservation.checked_out?
          params[:reservation][:date_out] = start_date
        else
          params[:reservation][:reservation_out] = start_date
        end
        params[:reservation][:reservation_in] = end_date
      rescue
        raise "Invalid Date"
      end

      if !Reservation.valid_reservation?(start_date, end_date, Item.find_by_id(reservation.item_id), reservation.quantity, reservation, (current_user and current_user.admin?))
        raise "Conflicting Reservation"
      end
    end

    reservation.update_attributes(params[:reservation])
    if params[:return_address] != nil
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
