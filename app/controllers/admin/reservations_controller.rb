class Admin::ReservationsController < ApplicationController

  respond_to :html, :json
  before_filter :is_admin

  def index
    name = params[:name]
    item = params[:item]
    status = params[:status]

    if params[:canceled]
      @reservations = Reservation.all
      @canceled = true
    else
      @reservations = Reservation.hide_canceled
    end

    if status == "Canceled"
      @reservations = @reservations.canceled
    elsif status == "Reserved"
      @reservations = @reservations.reserved
    elsif status == "Checked Out"
      @reservations = @reservations.checked_out
    elsif status == "Checked In"
      @reservations = @reservations.checked_in
    end

    if name && name != ""
      @reservations = @reservations.for_user(name)
    end

    if item && item != ""
      @reservations = @reservations.for_item(item)
    end

    respond_to do |format|
      format.html
      format.xls # { send_data @reservations.to_csv(col_sep: "\t") }
    end
  end

  def filter
    redirect_to admin_reservations_path(:name => params[:name], :item => params[:item], :status => params[:status], :date_out => params[:date_out], :date_out => params[:date_out])
  end

  def update
    @reservation = Reservation.find(params[:id])
    @reservation.update_attributes(params[:reservation])
    respond_with @reservation
  end

  def checkout
    reservation = get_reservation(params)
    checkout_helper(reservation, reservation.user)
    redirect_to :back
  end

  def get_reservation(parameters)
    if parameters[:reserved]
      reservation = Reservation.find_by_id(parameters[:id])
    else
      user = User.find_by_email(parameters[:email])
      item = Item.find_by_id(parameters[:item])
      reservation = user ? Reservation.find_by_user_id_and_item_id(user.id, item.id) : nil
      if not reservation
        reservation = Reservation.new
        reservation.quantity = parameters[:quantity].to_i
        reservation.item = item
        reservation.user = user
      end
    end
    reservation
  end

  def checkout_helper(reservation, user)
    if user and Reservation.checkout(reservation)
      flash[:notice] = "Item #{reservation.item.name} was successfully checked out to #{reservation.user.name}."
    else
      flash[:warning] = "Item #{reservation.item.name} could not be checked out due to an existing reservation."
      flash[:warning] = "User does not exist. Please create an account for the user via the User Dashboard before checking out." if !user
    end
  end

  def checkin
    reservation = Reservation.find_by_id(params[:id])
    reservation.check_in
    redirect_to :back, notice: "Item #{reservation.item.name} was successfully checked in."
  end

  # def archive
  #   reservation = Reservation.find_by_id(params[:id])
  #   reservation.archive
  #   redirect_to :back, notice: "Reservation was successfully archived."
  # end

end
