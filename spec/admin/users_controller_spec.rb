require 'spec_helper'

describe Admin::UsersController, :type => :controller do

  describe 'admin logged in' do
    before (:each) do
      request.env["devise.mapping"] = Devise.mappings[:user]
      get :new
      @admin = User.create!(:name => 'Test Admin', :email => 'admin@email.com', :phone => '1234567890', :category => User::ADMIN, :password => 'password')
      @admin.confirmed_at = Time.now
      @admin.save
      sign_in @admin
      @user = User.create!(:name => 'Test User', :email => 'user@email.com', :phone => '1234567890', :category => User::BASIC, :password => 'password')
      @user.confirmed_at = Time.now
      @user.save

      @user_params = {:user => {:name => 'Test User', :email => 'newuser@email.com', :phone => '1234567890', :category => User::BASIC, :password => 'password'} }
    end

    it 'should be able to update user' do
      old_count = User.count
      User.stub(:find).and_return(@user)
      put :update, {:id => @user.id, :user => {:phone => 'new_phone'}}
      new_count = User.count
      new_count.should == old_count
      @user.phone.should == 'new_phone'
    end
    it 'should be able to create user' do
      old_count = User.count
      post :create, @user_params
      new_count = User.count
      new_count.should == old_count + 1
    end
  end

  describe 'admin not logged in' do
    before (:each) do
      request.env["devise.mapping"] = Devise.mappings[:user]
      get :new
      @nonadmin = User.create!(:name => 'Test Admin', :email => 'admin@email.com', :phone => '1234567890', :category => User::BASIC, :password => 'password')
      @nonadmin.confirmed_at = Time.now
      @nonadmin.save
      sign_in @nonadmin
      @user = User.create!(:name => 'Test User', :email => 'user@email.com', :phone => '1234567890', :category => User::BASIC, :password => 'password')
      @user.confirmed_at = Time.now
      @user.save

      @user_params = {:user => {:name => 'Test User', :email => 'newuser@email.com', :phone => '1234567890', :category => User::BASIC, :password => 'password'} }
    end

    it 'should not be able to update user' do
      old_count = User.count
      User.stub(:find).and_return(@user)
      put :update, {:id => @user.id, :user => {:phone => 'new_phone'}}
      new_count = User.count
      new_count.should == old_count
      @user.phone.should_not == 'new_phone'
    end
    it 'should not be able to create user' do
      old_count = User.count
      post :create, @user_params
      new_count = User.count
      new_count.should == old_count
    end
  end
end
