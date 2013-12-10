class Reservation < ActiveRecord::Base

  attr_accessible :canceled, :date_in, :date_out, :item_id, :item, :notes, :quantity, :reservation_in, :reservation_out, :user, :user_id


  # validates_date :date_in, :on_or_after => lambda{|m| m.date_out}, :allow_nil => true
  # validates_date :date_out, :on_or_before => lambda{|m| m.date_in}, :allow_nil => true
  # validates_date :reservation_in, :on_or_after => lambda{|m| m.reservation_out}, :allow_nil => true
  # validates_date :reservation_out, :on_or_before => lambda{|m| m.reservation_in}, :allow_nil => true

  belongs_to :user
  belongs_to :item

  STATUSES = ["Canceled", "Checked Out", "Checked In", "Reserved"]

  # Supports faculty checkout dates up until the end of the summer session of 2016
  # For additional support, add dates to the top of this list.

  scope :canceled, -> { where(canceled: true) }

  scope :reserved, -> { where(:date_out => nil) }
  scope :checked_out, -> { where("date_out IS NOT NULL AND date_in IS NULL") }
  scope :checked_in, -> { where("date_out IS NOT NULL AND date_in IS NOT NULL") }


  scope :reserved_or_checked_out, -> { where("(date_out IS NOT NULL AND date_in IS NULL) OR date_out IS NULL") }

  scope :within_dates, lambda { |start_date, end_date|
    where("(date_out IS NULL AND reservation_out >= ? AND reservation_in <= ?) OR (date_out IS NOT NULL AND date_in IS NULL AND date_out >= ? AND reservation_in <= ?) OR (date_out IS NOT NULL AND date_in IS NOT NULL AND date_out >= ? AND date_in <= ?)", start_date, end_date, start_date, end_date, start_date, end_date) }

  scope :for_user, lambda {|name| joins(:user).where("users.name like ?", "%"+name+"%")}
  scope :for_item, lambda {|name| joins(:item).where("items.name like ?", "%"+name+"%")}

  scope :checkout_reservation, lambda {where("reservation_out <= ? AND reservation_in >= ?", Date.today, Date.today).readonly(false)}
  scope :has_quantity, lambda {|q| where("reservations.quantity = ?", q)}

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

  def reserved_or_checked_out?
    reserved? or checked_out?
  end

  def overlaps?(start_date, end_date)
    res_start = date_out || reservation_out
    res_end = reservation_in

    start_date_overlap = date_within_range?(res_start, start_date, end_date)
    end_date_overlap = date_within_range?(res_end, start_date, end_date)

    begin
      date_within_res = (res_start <= start_date and res_end >= end_date)
      date_including_res = (res_start >= start_date and res_end <= end_date)
    rescue NoMethodError
      date_within_res = false
      date_including_res = false
    end

    puts start_date_overlap
    puts end_date_overlap
    puts date_within_res
    puts date_including_res
    puts res_start
    puts start_date
    puts res_end
    puts end_date
    puts res_start <= start_date
    puts res_end >= end_date

    return start_date_overlap || end_date_overlap || date_within_res || date_including_res
  end

  def date_within_range?(date, start_range, end_range)
    begin
      date >= start_range and date <= end_range
    rescue NoMethodError
      return false
    end
  end

  def check_in
    update_attribute(:date_in, Date.today)
  end

  def get_max_item_quantity(start_date=Date.today, end_date=Date.today)
    return item.quantity_available(start_date, end_date, self)
  end

  # def archive
  #   update_attribute(:archived, true)
  # end
  #
  # def self.hide_archived
  #   where(:archived => false)
  # end

  def get_due_date
    self.item.get_due_date_business_days(DateTime.now)
  end

  def self.hide_canceled
    where(:canceled => false)
  end

  def cancel
    update_attribute(:canceled, true)
  end

  def self.on_weekend?(start_date, end_date)
    start_date.wday == 0 or start_date.wday == 6 or end_date.wday == 0 or end_date.wday == 6
  end

  def self.valid_reservation?(start_date, end_date, item, quantity_desired, exclude_reservation= nil, current_user_admin= false)
    raise StandardError, " the quantity requested must be greater than 0." if quantity_desired == 0
    Reservation.valid_dates?(start_date, end_date, item, current_user_admin)
    if item.quantity_available(start_date, end_date, exclude_reservation) < quantity_desired
      raise StandardError, " the quantity requested is not available."
    else
      true
    end
  end

  def self.valid_dates?(start_date, end_date, item, current_user_admin)
    return if current_user_admin
    if end_date > item.upper_limit(start_date)
      raise StandardError, " the requested length exceeds the max for this item: " + item.get_due_date.to_s + " business days."
    elsif on_weekend?(start_date, end_date)
      raise StandardError, " reservations cannot start or end on weekends."
    end
  end

  def self.make_reservation(user, item, start_date, end_date, quantity_desired)
    start_date = Date.strptime(start_date, "%m/%d/%Y")
    end_date = Date.strptime(end_date, "%m/%d/%Y")
    Reservation.create!(:user_id => user.id, :item_id => item.id, :reservation_out => start_date, :reservation_in => end_date, :quantity => quantity_desired) if valid_reservation?(start_date, end_date, item, quantity_desired)
  end

  def self.checkout(reservation, user)
    number_available = reservation.get_max_item_quantity(Date.today, Date.today)
    reservation.date_out = Date.today
    due_date = reservation.get_due_date

    begin
      reservation.reservation_in = due_date if reservation.reservation_in > due_date
    rescue NoMethodError
      Reservation.find_valid_end_date(reservation, due_date) if number_available >= reservation.quantity
    end

    number_available >= reservation.quantity ? reservation.save! : false
  end

  def self.find_valid_end_date(reservation, due_date)
    if reservation.user.category_str == "Faculty"
      reservation.reservation_in = Reservation.find_end_of_current_semester
    else
      end_date = Date.today
      while end_date + 1 <= due_date and reservation.quantity <= reservation.get_max_item_quantity(Date.today, end_date+1) do
        end_date += 1
      end
      reservation.reservation_in = end_date
    end
  end

  def self.find_end_of_current_semester
    current_month = Date.today.month
    if current_month.between?(1,5)
      end_month = 5
    elsif current_month.between?(6,8)
      end_month = 8
    else
      end_month = 12
    end
    return Date.new(Date.today.year, end_month, 20)
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


  def self.filter(params, date_out, date_in)
    reservations = canceled_res(reservations, params[:canceled])
    reservations = status_res(reservations, params[:status])
    reservations = user_item_res(reservations, params[:name], params[:item])
    reservations = date_res(reservations, date_out, date_in)
  end

  private

  def self.canceled_res(reservations, canceled)
    if canceled
      Reservation.all
    else
      Reservation.hide_canceled
    end
  end

  def self.status_res(reservations, status)
    if STATUSES.include? status
      reservations.send(status.parameterize.underscore.to_sym)
    else
      reservations
    end
  end

  def self.user_item_res(reservations, name, item)
    reservations = reservations.for_user(name) if not name.to_s.empty?
    reservations = reservations.for_item(item) if not item.to_s.empty?
    reservations
  end

  def self.date_res(reservations, date_out, date_in)
    if not date_out.to_s.empty? and not date_in.to_s.empty?
      reservations.within_dates(date_out, date_in)
    else
      reservations
    end
  end

  def self.format_date date
    self.strip_date(date).strftime("%Y-%m-%d")
  end

  def self.strip_date date
    if not date.to_s.empty?
      Date.strptime(date, "%m/%d/%Y")
    end
  end
end
