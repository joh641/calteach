class UserMailer < ActionMailer::Base
  default from: "calteach@berkeley.edu"

  def return_reminder(user)
    @user = user
    @greeting = "Hi "

    mail to: user.email, subject: "Reservation Reminder"
  end
end
