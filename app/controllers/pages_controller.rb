class PagesController < ApplicationController
  def index
    @all_categories = Item.all_categories
    @all_items = Item.all
  end
end
