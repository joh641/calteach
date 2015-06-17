class UserMailer < ActionMailer::Base
  default from: "calteach@berkeley.edu"

  def reservation_confirmation(reservation)
    @url = 'http://calteach.herokuapp.com/reservations'
    @user = reservation.user
    @item = reservation.item
    @quantity = reservation.quantity.to_s
    @date_out = reservation.reservation_out.to_s
    @date_in = reservation.reservation_in.to_s
    @greeting = "Hi "

    mail to: @user.email, subject: "Your reservation has been processed"
  end

  def checkout_confirmation(reservation)
    @url = 'http://calteach.berkeley.edu/cal-teach-program/advising-and-resources.php'
    @user = reservation.user
    @item = reservation.item
    @quantity = reservation.quantity.to_s
    @date_in = reservation.reservation_in.to_s
    @greeting = "Hi "

    mail to: @user.email, subject: "Your check-out has been processed"
  end

  def return_reminder(user, reservations)
    @url = 'http://calteach.berkeley.edu/cal-teach-program/advising-and-resources.php'
    @user = user
    @reservations = reservations
    @greeting = "Hi "

    mail to: @user.email, subject: "Your check-out is due tomorrow"
  end

  def overdue_reminder(user, reservations)
    @url = 'http://calteach.berkeley.edu/cal-teach-program/advising-and-resources.php'
    @user = user
    @reservations = reservations
    @greeting = "Hi "

    mail to: @user.email, subject: "Your check-out is now overdue"
  end
end
