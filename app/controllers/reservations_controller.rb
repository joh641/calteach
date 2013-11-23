class ReservationsController < ApplicationController
  respond_to :html, :json

  def index
    @reservations = current_user.reservations
  end

  def cancel
    reservation = Reservation.find_by_id(params[:id])
    reservation.canceled = true
    reservation.save
    flash[:notice] = "Reservation was successfully canceled"
    redirect_to reservations_path
  end

end
