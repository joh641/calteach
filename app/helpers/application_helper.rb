module ApplicationHelper
  def is_admin?
    current_user and current_user.admin?
  end
end
