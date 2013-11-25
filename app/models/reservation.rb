class Reservation < ActiveRecord::Base

  attr_accessible :date_in, :date_out, :item_id, :notes, :reservation_in, :reservation_out, :user_id, :user, :quantity

  # validates_date :date_in, :on_or_after => lambda{|m| m.date_out}, :allow_nil => true
  # validates_date :date_out, :on_or_before => lambda{|m| m.date_in}, :allow_nil => true
  # validates_date :reservation_in, :on_or_after => lambda{|m| m.reservation_out}, :allow_nil => true
  # validates_date :reservation_out, :on_or_before => lambda{|m| m.reservation_in}, :allow_nil => true

  belongs_to :user
  belongs_to :item

  def self.hide_archived
    Reservation.where(:archived => nil)
  end

  def self.email_reminders
    current_date = Date.today
    reminder_days = 1 # Time in seconds before due date
    checked_out = Reservation.where("date_out IS NOT NULL", :date_in => nil)
    puts Reservation.first.reservation_out
    puts Reservation.first.reservation_in    
    checked_out.each do |current_reservation|
      puts "FINDME"
      if (current_reservation.reservation_in  \
          and (current_reservation.reservation_in - current_date) > 0 \
          and (current_reservation.reservation_in - current_date) == reminder_days)
        user = User.find(current_reservation.user_id)
        UserMailer.return_reminder(user).deliver
      end
    end
  end

  def get_status
    if self.archived
      "Archived"
    elsif self.canceled
      "Canceled"
    elsif self.date_in and self.date_out
      "Checked In"
    elsif self.date_out and not self.date_in
      "Checked Out"
    else
      "Reserved"
    end    
  end

  def overlaps?(start_date, end_date)
    (self.reservation_out >= start_date and self.reservation_out <= end_date) or
    (self.reservation_in >= start_date and self.reservation_in <= end_date) or
    (self.reservation_out <= start_date and self.reservation_in >= end_date) or
    (self.date_out and self.date_out >= start_date and self.date_out <= end_date)
  end

  def self.make_reservation(user, item, start_date, end_date, quantity_desired)
    if start_date != "" and end_date != ""
      start_date = Date.strptime(start_date, "%m/%d/%Y")
      end_date = Date.strptime(end_date, "%m/%d/%Y")
      false
      self.create(:user_id => user.id, :item_id => item.id, :reservation_out => start_date, :reservation_in => end_date, :quantity => quantity_desired) if self.valid_reservation?(start_date, end_date, item, quantity_desired)
    else
      false
    end
  end

 #Performs basic sanity checks on the start and end dates.
  def self.valid_reservation?(start_date, end_date, item, quantity_desired)
    if quantity_desired == 0
      false
    elsif item.quantity_available(start_date, end_date) < quantity_desired
      false
    elsif end_date > item.get_due_date.business_days.after(start_date.to_datetime).to_date
      false
    else
      true
    end
  end

  def self.checkout(reservation)
    number_available = reservation.item.quantity_available
    checkout_date = Date.today
    due_date = reservation.item.get_due_date.business_days.after(DateTime.now).to_date
    reservation.reservation_out = checkout_date
    reservation.reservation_in = due_date if !reservation.reservation_in or (reservation.reservation_in and reservation.reservation_in > due_date)
    reservation.date_out = checkout_date
    if number_available >= reservation.quantity
      reservation.save
    else
      false
    end
  end

end
