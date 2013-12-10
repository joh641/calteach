module ApplicationHelper
  def is_admin?
    current_user and current_user.admin?
  end

  def get_formatted_date set_date, editable_date
    if set_date != nil
      render "admin/reservations/date", :date => format(set_date)
    else
      render "admin/reservations/res_date", :date => format(editable_date)
    end
  end
  
  def format(str)
    str.strftime("%m/%d/%Y")
  end
end
