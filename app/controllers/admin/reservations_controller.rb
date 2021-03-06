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
    checkout_helper(reservation, reservation.user, params[:reserved], current_user)
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

      reservation = Reservation.for_user(user.name).for_item(item.name).reserved.checkout_reservation.has_quantity(parameters[:quantity].to_i).first if user

      unless reservation
        reservation_out = Date.strptime(parameters[:reservation_out], "%m/%d/%Y")
        reservation_in = Date.strptime(parameters[:reservation_in], "%m/%d/%Y")

        reservation = Reservation.new(quantity: parameters[:quantity].to_i, reservation_out: reservation_out, reservation_in: reservation_in, item: item, user: user)
      end
    end
    add_notes(reservation, parameters[:notes])

    reservation
  end

  def checkout_helper(reservation, user, reserved, current_user)
    if user
      if reservation.quantity and reservation.quantity > 0
        if Reservation.checkout(reservation, user, reserved, current_user.admin?)
          UserMailer.checkout_confirmation(reservation).deliver
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
    @reservations = @reservations.reverse

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

  def add_notes(reservation, notes)
    reservation.notes = reservation.notes.to_s.empty? ? notes : reservation.notes + " " + notes if notes
  end

end
