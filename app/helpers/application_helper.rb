module ApplicationHelper
  def is_admin?
    current_user and current_user.admin?
  end

  def date_out reservation
    if reservation.date_out != nil
      render "admin/reservations/date", :date => format(reservation.date_out)
    else
      render "admin/reservations/res_date", :date => format(reservation.reservation_out)
    end
  end

  def date_in reservation
    if reservation.date_in != nil
      render "admin/reservations/date", :date => format(reservation.date_in)
    else
      render "admin/reservations/res_date", :date => format(reservation.reservation_in)
    end
  end

  def format(str)
    str.strftime("%m/%d/%Y")
  end
end
