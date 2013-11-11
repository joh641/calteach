require 'spec_helper'

describe User do

  it 'should return correct category' do
    @user = User.create!(:name => 'Test User', :email => 'user@email.com', :phone => '1234567890', :category => User::BASIC, :password => 'password')
    @user.category_str.should == "Basic"
    @user.update_attribute(:category, User::ADMIN)
    @user.category_str.should == "Admin"
    @user.admin?.should == true
    @user.update_attribute(:category, User::FACULTY)
    @user.category_str.should == "Faculty"
  end

end
