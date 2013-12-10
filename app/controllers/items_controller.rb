class ItemsController < ApplicationController

  before_filter :is_admin, :except => [:index, :show]

  def index
    @items = params[:inactive] ? Item.inactive.order(:name) : Item.active.order(:name)
    @inactive = params[:inactive]
    
    session[:tag_query] = params[:tag_query]
    session[:search_query] = params[:search_query]

    if is_valid_query(session[:search_query])
      @items = @items.where("name like ?", "%#{session[:search_query]}%")
    end

    if is_valid_query(session[:tag_query])
      @items = @items.tagged_with(session[:tag_query])
    end
  end

  def is_valid_query(input)
    return ! [nil, ""].include?(input)
  end

  def show
    @item = Item.find_by_id(params[:id])
    @reservations = @item.reservations

    @availability = {}
    d = Date.today
    60.times do
      @availability[d] = @item.quantity_available(d, d)
      d = d + 1
    end

  end

  def import
    Item.import(params[:file])
    redirect_to items_path, notice: "Items imported!"
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(params[:item])
    if @item.quantity and @item.quantity < 1
      flash[:warning] = "Invalid quantity specified."
      render action: "/new"
    elsif @item.save
      redirect_to items_path, notice: "Item #{@item.name} was successfully created."
    else
      flash[:warning] = "Item creation was unsuccessful."
      render action: "new"
    end
  end

  def edit
    @item = Item.find_by_id(params[:id])
  end

  def update
    @item = Item.find_by_id(params[:id])
    if @item.update_attributes(params[:item])
      redirect_to item_path(@item), notice: "Item #{@item.name} was successfully updated."
    else
      flash[:warning] = "Item update was unsuccessful."
      render action: "edit"
    end
  end

  def destroy
    @item = Item.find_by_id(params[:id])
    @item.soft_delete
    redirect_and_flash("Item", @item.name, "archived")
  end

  def unarchive
    @item = Item.find_by_id(params[:id])
    @item.unarchive
    redirect_and_flash("Item", @item.name, "unarchived")
  end

  def checkout
    @item = Item.find_by_id(params[:id])
  end

  def update_due_date_categories
    if params[:add]
      Item.update_due_date_categories(params[:category], params[:days].to_i)
    else 
      @due_date_categories.each do |category|
        Item.update_due_date_categories(category, params["#{category}-days"].to_i)
      end
    end
    redirect_to items_path, notice: "Due date categories successfully updated."
  end

  def delete_due_date_category
    Item.delete_due_date_category(params[:category])
    redirect_to items_path, notice: "Due date category was successfully deleted."
  end

end
