class Admin::ReservationsController < ApplicationController
  def index
    if params[:archived]
      @reservations = Reservation.all
      @archived = true
    else
      @reservations = Reservation.hide_archived
    end
  end
end
