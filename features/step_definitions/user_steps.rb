Given /^there is an admin$/ do
  user = User.new({:name => 'admin',
                :password => 'password',
                :email => 'admin@gmail.com',

              })
  user.confirmed_at = Time.now
  user.save(:validate => false)

end

Given /^there is a user$/ do
  user = User.new({:name => 'user',
                :password => 'password',
                :email => 'user@gmail.com'
              })
  user.confirmed_at = Time.now
  user.save(:validate => false)
end

And /^I am logged into the admin panel$/ do
  pending
  visit '/users/sign_in'
  fill_in 'user[email]', :with => 'admin@gmail.com'
  fill_in 'user[password]', :with => 'password'
  click_button 'Sign in'
  if page.respond_to? :should
    page.should have_content('Signed in successfully.')
  else
    assert page.has_content?('Signed in successfully')
  end
end

And /^I am logged into the user panel$/ do
  pending
  visit '/users/sign_in'
  fill_in 'user[email]', :with => 'user@gmail.com'
  fill_in 'user[password]', :with => 'password'
  click_button 'Sign in'
  if page.respond_to? :should
    page.should have_content('Signed in successfully.')
  else
    assert page.has_content?('Signed in successfully')
  end
end


Then /^the type of "([^"]*)" should be "([^"]*)"$/ do |user_name, user_type|
  type_constant = 0
  if user_type == "admin"
    type_constant = User::ADMIN
  elsif user_type == "faculty"
    type_constant = User::FACULTY
  elsif user_type == "basic"
    type_constant = User::BASIC
  end

  User.find_by_name(user_name).type == type_constant
end