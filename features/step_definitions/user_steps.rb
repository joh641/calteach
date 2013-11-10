Given /^there is an admin$/ do
  user = User.new({:name => 'admin',
                :password => 'password',
                :email => 'cucumberadmin@gmail.com',
                :category => User::ADMIN
              })
  user.confirmed_at = Time.now
  user.save(:validate => false)

end

Given /^there is a user$/ do
  user = User.new({:name => 'user',
                :password => 'password',
                :email => 'cucumberuser@gmail.com',
                :category => User::BASIC
              })
  user.confirmed_at = Time.now
  user.save(:validate => false)
end

And /^I am logged into the admin panel$/ do
  visit '/users/sign_in'
  fill_in 'user[email]', :with => 'cucumberadmin@gmail.com'
  fill_in 'user[password]', :with => 'password'
  click_button 'Sign in'
  if page.respond_to? :should
    page.should have_content('Signed in successfully.')
  else
    assert page.has_content?('Signed in successfully')
  end
end

And /^I am logged into the user panel$/ do
  visit '/users/sign_in'
  fill_in 'user[email]', :with => 'cucumberuser@gmail.com'
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