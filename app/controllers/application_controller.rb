class ApplicationController < ActionController::Base

  protect_from_forgery

  before_filter :all_tags, :due_date_categories

  def after_sign_in_path_for(resource)
    session.delete(:return_to) || stored_location_for(resource) || signed_in_root_path(resource)
  end

  def all_tags
    @all_tags = ActsAsTaggableOn::Tag.all.map { |tag| tag.name }
  end

  def due_date_categories
    @due_date_categories = Item.due_date_categories
  end

  def is_admin?
    current_user && current_user.admin?
  end

  def is_admin
    if not is_admin?
      flash[:error] = "Error: Not an admin"
      redirect_to root_path
      return
    end
    return true
  end

  def redirect_and_flash(model, name, status)
    redirect_to :back, notice: "#{model} #{name} was successfully #{status}."
  end
end
