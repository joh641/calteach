class Admin::UsersController < ApplicationController

  before_filter :is_admin

  def index
    if params[:inactive]
      @users = User.inactive
      @inactive = true
    else
      @users = User.active
    end
  end

  def new
    @user = User.new
    @disabled = false
  end

  def edit
    @user = User.find_by id: params[:id]
    @disabled = true
  end

  def create
    @user = User.new(user_params)
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
    @user = User.find_by id: params[:id]
    if @user.update_attributes(user_params)
      redirect_to admin_users_path, notice: 'User was successfully updated.'
    else
      flash[:warning] = "User could not be updated."
      render action: "edit"
    end
  end

  def destroy
    @user = User.find_by id: params[:id]
    @user.soft_delete
    redirect_and_flash("User", @user.name, "deactivated")
  end

  def activate
    @user = User.find_by id: params[:id]
    @user.activate
    redirect_and_flash("User", @user.name, "activated")
  end

  def user_params
    params.require(:user)
          .permit(:name, :email, :phone, :category)
  end

end
