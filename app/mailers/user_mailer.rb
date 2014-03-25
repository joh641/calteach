class UserMailer < ActionMailer::Base
  default from: "calteach@berkeley.edu"

  def return_reminder(user, items)
    @url = 'http://calteach.berkeley.edu/cal-teach-program/advising-and-resources.php'
    @user = user
    @items = items
    @greeting = "Dear "

    mail to: @user.email, subject: "Reminder: Cal Teach Resource Center Items Due"
  end

  def overdue_reminder(user, items)
    @url = 'http://calteach.berkeley.edu/cal-teach-program/advising-and-resources.php'
    @user = user
    @items = items
    @greeting = "Dear "

    mail to: @user.email, subject: "Cal Teach Resource Center Items Overdue"
  end
end
