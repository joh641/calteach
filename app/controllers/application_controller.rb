class ApplicationController < ActionController::Base

  protect_from_forgery

  before_filter :all_tags, :due_date_categories

  def all_tags
    @all_tags = ActsAsTaggableOn::Tag.all.map { |tag| tag.name }
  end

  def due_date_categories
    @due_date_categories = Item.due_date_categories
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
