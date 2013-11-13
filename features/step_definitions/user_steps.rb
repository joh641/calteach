Given /^there is an admin$/ do
  @admin_email = 'cucumberadmin@gmail.com'
  user = User.new({:name => 'admin',
                :password => 'password',
                :email => @admin_email,
                :category => User::ADMIN
              })
  user.confirmed_at = Time.zone.now
  user.save(:validate => false)

end

Given /^there is a user$/ do
  @user_email = 'cucumberuser@gmail.com'
  user = User.new({:name => 'user',
                :password => 'password',
                :email => @user_email,
                :category => User::BASIC
              })
  user.confirmed_at = Time.zone.now
  user.save(:validate => false)
end

And /^I am logged into the admin panel$/ do
  visit '/users/sign_in'
  fill_in 'user[email]', :with => @admin_email
  fill_in 'user[password]', :with => 'password'
  click_button 'Sign in'
  if page.respond_to? :should
    page.should have_content('Signed in successfully.')
  else
    assert page.has_content?('Signed in successfully')
  end
end

And /^I edit "([^"]*)"$/ do |user|
  user = User.find_by_name(user)
  click_link("edit#{user.id}")
end

And /^I destroy "([^"]*)"$/ do |user|
  user = User.find_by_name(user)
  click_link("destroy#{user.id}")
end

And /^I am logged into the user panel$/ do
  visit '/users/sign_in'
  fill_in 'user[email]', :with => @user_email
  fill_in 'user[password]', :with => 'password'
  click_button 'Sign in'
  if page.respond_to? :should
    page.should have_content('Signed in successfully.')
  else
    assert page.has_content?('Signed in successfully')
  end
end


Then /^the type of "([^"]*)" should be "([^"]*)"$/ do |user_name, user_category|
  category_constant = 0
  if user_category == "admin"
    category_constant = User::ADMIN
  elsif user_category == "faculty"
    category_constant = User::FACULTY
  elsif user_category == "basic"
    category_constant = User::BASIC
  end

  User.find_by_name(user_name).category == category_constant
end

Then /^the created email account should receive a temporary password and confirmation$/ do
  email = ActionMailer::Base.deliveries.first
  email.body.should include("confirm")
  email.body.should include("change your password")
end

