class Admin::UsersController < ApplicationController

  before_filter :is_admin

  def index
    if params[:inactive]
      @users = User.inactive.find(:all, :order => "name ASC")
      @inactive = true
    else
      @users = User.active.find(:all, :order => "name ASC")
    end
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
    poss_characters =  [('a'..'z'),('A'..'Z')].map{|i| i.to_a}.flatten
    random_password  =  (0...8).map{ poss_characters[rand(poss_characters.length)] }.join
    @user.password = random_password
    @user.password_confirmation = random_password
    @user.admin_created = true
    if @user.save
      redirect_to admin_users_path, notice: 'User was successfully created.'
    else
      render action: "new"
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      redirect_to admin_users_path, notice: 'User was successfully updated.'
    else
      flash[:warning] = "User could not be updated."
      render action: "edit"
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.soft_delete
    redirect_to admin_users_path, notice: "User #{@user.name} was successfully deactivated."
  end

  def activate
    @user = User.find(params[:id])
    @user.update_attribute(:inactive, false)
    redirect_to admin_users_path, notice: "User #{@user.name} was successfully activated."
  end


end
