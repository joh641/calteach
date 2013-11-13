class ApplicationController < ActionController::Base

  protect_from_forgery

  before_filter :all_categories

  def all_categories
    @all_categories = Item.all_categories
  end

  def is_admin
    if !current_user || !current_user.admin?
      flash[:error] = "Error: Not an admin"
      redirect_to root_path
      return
    end
    return false
  end

end
