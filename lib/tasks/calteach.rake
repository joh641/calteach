namespace :calteach do
  desc "Sends email reminders for items due the next day"
  task :email_reminders => :environment do
    puts "Emailing reminders..."
    Reservation.email_reminders
  end

  desc "Send late reminders for items that are overdue"
  task :overdue_reminders => :environment do
    puts "Sending overdue notices..."
    Reservation.overdue_reminders
  end
end