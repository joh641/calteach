class Reservation < ActiveRecord::Base

  attr_accessible :canceled, :date_in, :date_out, :item_id, :notes, :quantity, :reservation_in, :reservation_out, :user, :user_id


  # validates_date :date_in, :on_or_after => lambda{|m| m.date_out}, :allow_nil => true
  # validates_date :date_out, :on_or_before => lambda{|m| m.date_in}, :allow_nil => true
  # validates_date :reservation_in, :on_or_after => lambda{|m| m.reservation_out}, :allow_nil => true
  # validates_date :reservation_out, :on_or_before => lambda{|m| m.reservation_in}, :allow_nil => true

  belongs_to :user
  belongs_to :item

  STATUSES = ["Canceled", "Checked Out", "Checked In", "Reserved"]

  scope :canceled, -> { where(canceled: true) }
  scope :reserved, -> { where(:date_out => nil) }
  scope :checked_out, -> { where("date_out IS NOT NULL AND date_in IS NULL") }
  scope :checked_in, -> { where("date_out IS NOT NULL AND date_in IS NOT NULL") }

  scope :within_dates, lambda { |start_date, end_date|
    where("reservation_out > ? AND reservation_in < ?", start_date, end_date) }

  scope :for_user, lambda {|name| joins(:user).where("users.name = ?", name)}
  scope :for_item, lambda {|name| joins(:item).where("items.name = ?", name)}



  def get_status
    # if archived
    #   "Archived"
    if canceled?
      "Canceled"
    elsif checked_in?
      "Checked In"
    elsif checked_out?
      Date.today > reservation_in ? "Overdue" : "Checked Out"
    else
      "Reserved"
    end
  end

  def canceled?
    canceled
  end

  def checked_in?
    date_in and date_out
  end

  def checked_out?
    date_out and not date_in
  end

  def reserved?
    not (canceled? or checked_in? or checked_out?)
  end

  def overlaps?(start_date, end_date)
    (reservation_out and reservation_out >= start_date and reservation_out <= end_date) or
    (reservation_in and reservation_in >= start_date and reservation_in <= end_date) or
    (reservation_out and reservation_in and reservation_out <= start_date and reservation_in >= end_date) or
    (date_out and date_out >= start_date and date_out <= end_date)
  end

  def check_in
    update_attribute(:date_in, Date.today)
  end

  # def archive
  #   update_attribute(:archived, true)
  # end
  #
  # def self.hide_archived
  #   where(:archived => false)
  # end

  def self.hide_canceled
    where(:canceled => false)
  end

  def cancel
    update_attribute(:canceled, true)
  end

  def self.valid_reservation?(start_date, end_date, item, quantity_desired, exclude_reservation= nil, current_user_admin= false)
    if quantity_desired == 0
      false
    elsif end_date < start_date
      false
    elsif item.quantity_available(start_date, end_date, exclude_reservation) < quantity_desired
      false
    elsif not current_user_admin and end_date > item.get_due_date.business_days.after(start_date.to_datetime + 8.hours).to_date
      false
    #elsif not current_user_admin and (start_date#isweekend or end_date#isweekend)
    #  false
    else
      true
    end
  end

  def self.make_reservation(user, item, start_date, end_date, quantity_desired)
    if start_date != "" and end_date != ""
      start_date = Date.strptime(start_date, "%m/%d/%Y")
      end_date = Date.strptime(end_date, "%m/%d/%Y")
      false
      create(:user_id => user.id, :item_id => item.id, :reservation_out => start_date, :reservation_in => end_date, :quantity => quantity_desired) if valid_reservation?(start_date, end_date, item, quantity_desired)
    else
      false
    end
  end

  def self.checkout(reservation)
    number_available = reservation.item.quantity_available(Date.today, Date.today, reservation)
    checkout_date = Date.today
    due_date = reservation.item.get_due_date.business_days.after(DateTime.now).to_date

    if !reservation.reservation_in and number_available >= reservation.quantity
      end_date = Date.today
      while end_date + 1 <= due_date and reservation.quantity <= reservation.item.quantity_available(Date.today, end_date+1, reservation) do
        end_date += 1
      end
      reservation.reservation_in = end_date
    elsif reservation.reservation_in and reservation.reservation_in > due_date
      reservation.reservation_in = due_date
    end
    reservation.date_out = checkout_date

    if number_available >= reservation.quantity
      reservation.save!
      true
    else
      false
    end
  end

  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << column_names
      all.each do |reservation|
        csv << reservation.attributes.values_at(*column_names)
      end
    end
  end

  def self.email_reminders
    current_date = Date.today
    reminder_days = 1 # Time in seconds before due date
    checked_out = where("date_out IS NOT NULL", :date_in => nil)
    checked_out.each do |current_reservation|
      if (current_reservation.reservation_in  \
          and (current_reservation.reservation_in - current_date) > 0 \
          and (current_reservation.reservation_in - current_date) == reminder_days)
        user = User.find(current_reservation.user_id)
        UserMailer.return_reminder(user).deliver
      end
    end
  end
end
