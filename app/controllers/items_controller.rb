class ItemsController < ApplicationController

  def show
    @item = Item.find_by_id(params[:id])
  end

  def index
    #TODO (Aatash) Now that we've moved "all_categories" to
    # application_controller.rb, we don't really need it here
    # nor in the other controller actions.
  	@all_categories = Item.all_categories
  	if params[:query]
  		#TODO (Yuxin) Is this even safe?
  		@query = params[:query]
  		@items = Item.where("lower(name) = ?", @query.downcase)
  	elsif
	    @items = Item.all
	  end
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
    @item.destroy
    flash[:notice] = "Item #{@item.name} was successfully deleted."
    redirect_to '/'
  end

  def reserve
    @item = Item.find_by_id(params[:id])
    flash[:notice] = "Your reservation attempt was unsuccessful."
    @reservation_successful = false
    start_date = DateTime.strptime(params[:reservation][:start_date], "%m/%d/%Y")
    end_date = DateTime.strptime(params[:reservation][:end_date], "%m/%d/%Y")
    item_number_available = @item.quantity

    @item.reservations.each do |reservation|
      #Existing checkout record of an item that has been returned (No conflict)
      if (reservation.date_in != nil)
        next
      #Attempted reservation happens before existing reservation. (No conflict) 
      elsif (reservation.reservation_out != nil and end_date < reservation.reservation_out)
        next
      #Attempted reservation happens after existing reservation. (No conflict)
      elsif (reservation.reservation_in != nil and end_date > reservation.reservation_in)
        next
      #Attempts to reserve an item after it would have been already checked out. (Conflict -- Invalid start date)
      elsif reservation.reservation_out != nil and reservation.reservation_in != nil and start_date > reservation.reservation_out and start_date < reservation.reservation_in
        item_number_available = item_number_available - 1
      #Attempts to reserve an item for too long that its conflict with pre-existing reservation. (Conflict -- Invalid end date)
      elsif reservation.reservation_out != nil and reservation.reservation_in != nil and end_date > reservation.reservation_out and end_date < reservation.reservation_in
        item_number_available = item_number_available - 1
      #Item is being held by VIP, no due date (Conflict)
      elsif reservation.date_out != nil and reservation.date_out == nil and nilreservation.reservation_in == nil
        item_number_available = item_number_available - 1
      end
    end

    if item_number_available != 0
      Reservation.create({:user_id => 1, :item_id => @item.id, :reservation_out => start_date, :reservation_in => end_date, :status => 'Reserved'})
      flash[:notice] = "Item #{@item.name} was successfully reserved." 
    end

    redirect_to item_path(@item)
  end

  def checkout
    @item = Item.find_by_id(params[:id])
  end

end
