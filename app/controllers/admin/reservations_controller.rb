class Admin::ReservationsController < ApplicationController

  respond_to :html, :json
  before_filter :is_admin

  def index
    @name = params[:name]
    @item = params[:item]
    status = params[:status]
    @default_status = status.to_s.empty? ? "All" : status
    @default_date_out = params[:date_out]
    @default_date_in = params[:date_in]

    @date_out = Date.strptime(params[:date_out], "%m/%d/%Y").strftime("%Y-%m-%d") if not params[:date_out].to_s.empty?
    @date_in = Date.strptime(params[:date_in], "%m/%d/%Y").strftime("%Y-%m-%d") if not params[:date_in].to_s.empty?

    if params[:canceled]
      @reservations = Reservation.all
      @canceled = true
    else
      @reservations = Reservation.hide_canceled
    end

    if Reservation::STATUSES.include? status
      sym_status = status.parameterize.underscore.to_sym
      @reservations = @reservations.send(sym_status)
    end

    @reservations = @reservations.for_user(@name) if not @name.to_s.empty?
    @reservations = @reservations.for_item(@item) if not @item.to_s.empty?

    @reservations = @reservations.within_dates(@date_out, @date_in) if @date_out and @date_in

    respond_to do |format|
      format.html
      format.xls # { send_data @reservations.to_csv(col_sep: "\t") }
    end
  end

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
  end

  def get_reservation(parameters)
    if parameters[:reserved]
      reservation = Reservation.find_by_id(parameters[:id])
      redirect_to :back
    else
      user = User.find_by_email(parameters[:email])
      item = Item.find_by_id(parameters[:item])

      if user
        Reservation.where(["user_id = ? and item_id = ?", user.id, item.id]).each do |r|
          if r.reserved? and r.reservation_out <= Date.today and r.reservation_in >= Date.today
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
      redirect_to item_path(item)
    end
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

  # def archive
  #   reservation = Reservation.find_by_id(params[:id])
  #   reservation.archive
  #   redirect_to :back, notice: "Reservation was successfully archived."
  # end

end
