class Reservation < ActiveRecord::Base
  attr_accessible :date_in, :date_out, :item_id, :notes, :reservation_in, :reservation_out, :user_id, :status

  belongs_to :user
  belongs_to :item

  def self.hide_archived
    Reservation.find(:all, :conditions => [ "status != 'Archived'" ])
  end

  def self.email_reminders
    current_time = Time.now
    reminder_time = 60 * 60 * 24 # Time in seconds before due date
    checked_out = Reservation.find(:all, 
      :conditions => [ "status == 'Checked Out'"])
    checked_out.each do |current_reservation|
      if current_reservation.reservation_in and (current_reservation.reservation_in - current_time) < reminder_time
        user = User.find(current_reservation.user_id)
        UserMailer.return_reminder(user).deliver
        puts "Mail sent successfully!"
      end
    end
  end

end
