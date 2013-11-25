Given(/^the cron task runs$/) do
  Reservation.email_reminders
end