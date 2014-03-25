class ApplicationController < ActionController::Base
  before_filter :configure_permitted_parameters, if: :devise_controller?

  protect_from_forgery

  before_filter :all_tags, :due_date_categories

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

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:name, :phone, :email, :password, :password_confirmation, :category) }
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:email, :password, :remember_me) }
  end

end
