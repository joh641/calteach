class ItemsController < ApplicationController

  before_filter :is_admin, :except => [:index, :show]

  def index
    if params[:inactive]
      @items = Item.inactive.order(:name)
      @inactive = true
    else
      @items = Item.active.order(:name)
    end

    if params[:query]
      #TODO (Yuxin) Is this even safe?
      @query = params[:query]
      @items = @items.where("lower(name) = ?", @query.downcase)
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
    @all_tags = ActsAsTaggableOn::Tag.all.map { |tag| tag.name }
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
    @all_tags = ActsAsTaggableOn::Tag.all.map { |tag| tag.name }
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

end
