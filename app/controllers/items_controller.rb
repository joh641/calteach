class ItemsController < ApplicationController

  def show
    @item = Item.find_by_id(params[:id])
  end

  def index
    @items = Item.all
  end

  def new
  end

  def create
    @item = Item.create(params[:item])
    redirect_to items_path
  end

  def edit
    @item = Item.find_by_id(params[:id])
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
    flash[:notice] = "Item #{@item.name} deleted."
    redirect_to items_path
  end
  
end
