class Admin::ReservationsController < ApplicationController

  respond_to :html, :json
  before_filter :is_admin

  # helper_method :index

  def filter
    redirect_to admin_reservations_path(:name => params[:name], :item => params[:item], :status => params[:status], :date_out => params[:date_out], :date_in => params[:date_in])
  end

  def update
    @reservation = Reservation.find(params[:id])
    @reservation.update_attributes(params[:reservation])
    respond_with @reservation
  end

  def checkout
    reservation = get_reservation(params)
    checkout_helper(reservation, reservation.user)
    if params[:reserved]
      redirect_to :back
    else
      redirect_to item_path(Item.find_by_id(params[:item]))
    end
  end

  def get_reservation(parameters)
    if parameters[:reserved]
      reservation = Reservation.find_by_id(parameters[:id])
    else
      user = User.find_by_email(parameters[:email])
      item = Item.find_by_id(parameters[:item])

      if user
        Reservation.where(["user_id = ? and item_id = ?", user.id, item.id]).each do |r|
          if r.reserved? and r.quantity.to_i == parameters[:quantity].to_i and r.reservation_out <= Date.today and r.reservation_in >= Date.today
            reservation = r
          end
        end
      end
      if not reservation
        reservation = Reservation.new
        reservation.quantity = parameters[:quantity].to_i
        reservation.item = item
        reservation.user = user
      end
    end
    
    reservation.notes = (!reservation.notes or reservation.notes == "") ? parameters[:notes] : reservation.notes + " " + parameters[:notes]
    reservation
  end

  def checkout_helper(reservation, user)
    if user
      if reservation.quantity and reservation.quantity > 0
        if Reservation.checkout(reservation, user)
          flash[:notice] = "Item #{reservation.item.name} was successfully checked out to #{reservation.user.name}."
        else
          flash[:warning] = "Item #{reservation.item.name} could not be checked out due to an existing reservation."
        end
      else
        flash[:warning] = "Reservation quantity cannot be zero"
      end
    else
      flash[:warning] = "User does not exist. Please create an account for the user via the User Dashboard before checking out."
    end
  end

  def checkin
    reservation = Reservation.find_by_id(params[:id])
    reservation.check_in
    redirect_to :back, notice: "Item #{reservation.item.name} was successfully checked in."
  end

  def index
    @name = params[:name]
    @item = params[:item]
    status = params[:status]
    @date_out = params[:date_out]
    @date_in = params[:date_in]
    @canceled = params[:canceled]

    get_dates(@date_out, @date_in)

    @reservations = Reservation.filter(params, @date_out, @date_in)
    @default_status = status.to_s.empty? ? "All" : status

    respond_to do |format|
      format.html
      format.xls # { send_data @reservations.to_csv(col_sep: "\t") }
    end
  end

  private

  def get_dates(date_out, date_in)
    @date_out = Reservation.format_date date_out if not date_out.to_s.empty?
    @date_in = Reservation.format_date date_in if not date_in.to_s.empty?
  end

end
