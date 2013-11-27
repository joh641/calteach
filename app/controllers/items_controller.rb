class ItemsController < ApplicationController

  before_filter :is_admin, :except => [:index, :show]

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

  def index
    if params[:inactive]
      @items = Item.inactive#.find(:all, :order => "name ASC")
      @inactive = true
    else
      @items = Item.active#.find(:all, :order => "name ASC")
    end

    if params[:query]
      #TODO (Yuxin) Is this even safe?
      @query = params[:query]
      @items = @items.where("lower(name) = ?", @query.downcase)
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
    if @item.save
      flash[:notice] = "Item #{@item.name} was successfully created."
      redirect_to items_path
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
      flash[:notice] = "Item #{@item.name} was successfully updated."
      redirect_to item_path(@item)
    else
      flash[:warning] = "Item update was unsuccessful."
      render action: "edit"
    end
  end

  def destroy
    @item = Item.find_by_id(params[:id])
    @item.soft_delete
    flash[:notice] = "Item #{@item.name} was successfully deleted."
    redirect_to '/'
  end

  def checkout
    @item = Item.find_by_id(params[:id])
  end

end
