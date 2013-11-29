module Admin::ReservationsHelper
  def date_out reservation
    if reservation.date_out != nil
      render "date", :date => format(reservation.date_out)
    else
      render "res_date", :date => format(reservation.reservation_out)
    end
  end

  def date_in reservation
    if reservation.date_in != nil
      render "date", :date => format(reservation.date_in)
    else
      render "res_date", :date => format(reservation.reservation_in)
    end
  end

  def format(str)
    str.strftime("%m/%d/%y")
  end
end
