class ItemsController < ApplicationController

  before_filter :is_admin, :except => [:index, :show]

  def index
    if params[:inactive]
      @items = Item.inactive.order(:name)
      @inactive = true
    else
      @items = Item.active.order(:name)
    end
    # change nil request param to empty string
    session[:tag_query] = params[:tag_query] == nil ? "" : params[:tag_query]
    session[:search_query] = params[:search_query] == nil ? "" : params[:search_query]

    #TODO (Yuxin) Is this even safe?
    if session[:search_query] != ""
      @items = @items.where("lower(name) = ?", session[:search_query].downcase)
    end

    if session[:tag_query] != ""
      @items = @items.tagged_with(session[:tag_query])
    end
    
    if !(params[:search_query] or params[:tag_query])
      session.delete(:search_query)
      session.delete(:tag_query)
    end
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
    redirect_to :back, notice: "Item #{@item.name} was successfully archived."
  end

  def unarchive
    @item = Item.find_by_id(params[:id])
    @item.unarchive
    redirect_to :back, notice: "Item #{@item.name} was successfully unarchived."
  end

  def checkout
    @item = Item.find_by_id(params[:id])
  end

  def update_due_date_categories
    Item.update_due_date_categories(params[:category], params[:days])
    redirect_to :back, notice: "Due date categories successfully updated."
  end

  def delete_due_date_category
    Item.delete_due_date_category(params[:category])
    redirect_to :back, notice: "Due date category was successfully deleted."
  end

end
