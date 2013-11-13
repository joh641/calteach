class UserMailer < ActionMailer::Base
  default from: "lauraimai@calteach.com"

  def return_reminder(user)
    @user = user
    @greeting = "Hi "

    mail to: user.email, subject: "Reservation Reminder"
  end
end
