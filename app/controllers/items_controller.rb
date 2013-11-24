class ItemsController < ApplicationController

  def show
    @item = Item.find_by_id(params[:id])
  end

  def index
    #TODO (Aatash) Now that we've moved "all_categories" to
    # application_controller.rb, we don't really need it here
    # nor in the other controller actions.
  	@all_categories = Item.all_categories


    if params[:inactive]
      @items = Item.inactive.find(:all, :order => "name ASC")
      @inactive = true
    else
      @items = Item.active.find(:all, :order => "name ASC")
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
    @all_categories = Item.all_categories
  end

  def create
    @item = Item.create(params[:item])
    flash[:notice] = "Item #{@item.name} was successfully created."
    redirect_to items_path
  end

  def edit
    @item = Item.find_by_id(params[:id])
    @all_categories = Item.all_categories
  end

  def update
    @item = Item.find_by_id(params[:id])
    @item.update_attributes(params[:item])
    flash[:notice] = "Item #{@item.name} was successfully updated."
    redirect_to item_path(@item)
  end

  def destroy
    @item = Item.find_by_id(params[:id])
    @item.soft_delete
    flash[:notice] = "Item #{@item.name} was successfully deleted."
    redirect_to '/'
  end

  def reserve
    @item = Item.find_by_id(params[:id])
    start_date = DateTime.strptime(params[:reservation][:start_date], "%m/%d/%Y")
    end_date = Date.strptime(params[:reservation][:end_date], "%m/%d/%Y")
    quantity_desired = params[:reservation][:quantity].to_i
    item_number_available = @item.quantity_available(start_date,end_date)

    if item_number_available >= quantity_desired and end_date <= @item.get_due_date.business_days.after(start_date).to_date
      Reservation.create({:user => current_user, :item_id => @item.id, :reservation_out => start_date.to_date, :reservation_in => end_date, :quantity => quantity_desired})
      flash[:notice] = "Item #{@item.name} was successfully reserved."
    else
      flash[:warning] = "Your reservation attempt was unsuccessful."
    end

    redirect_to item_path(@item)
  end

  def checkout
    @item = Item.find_by_id(params[:id])
  end

end
