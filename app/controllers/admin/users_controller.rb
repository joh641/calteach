class Admin::UsersController < ApplicationController

  def index
    @users = User.find(:all, :order => "name ASC")
  end

  def new
    @user = User.new
    @disabled = false
  end

  def edit
    @user = User.find(params[:id])
    @disabled = true
  end

  def create
    @user = User.new(params[:user])
    #TODO: Generate random password. Send user email w/ password
    @user.password = 'password'
    if @user.save
      redirect_to admin_users_path, notice: 'User was successful created.'
      puts '*' * 50
    else
      render action: "new"
    end
  end

  def update
    @user = User.find(params[:id])

    if @user.update_attributes(params[:user])
      redirect_to admin_users_path, notice: 'User was successfully updated.'
    else
      flash[:error] = "User couldn't be updated"
      render action: "edit"
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to admin_users_path
  end

end
