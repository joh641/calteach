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
    poss_characters =  [('a'..'z'),('A'..'Z')].map{|i| i.to_a}.flatten
    random_password  =  (0...8).map{ poss_characters[rand(poss_characters.length)] }.join
    @user.password = random_password
    @user.password_confirmation = random_password
    if @user.save
      UserMailer.account_created_email(@user, random_password).deliver
      redirect_to admin_users_path, notice: 'User was successful created.'
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
