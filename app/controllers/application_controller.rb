class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :all_categories

  def all_categories
    @all_categories = Item.all_categories
  end
end
