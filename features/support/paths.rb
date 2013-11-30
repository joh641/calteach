# TL;DR: YOU SHOULD DELETE THIS FILE
#
# This file is used by web_steps.rb, which you should also delete
#
# You have been warned
module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)
    case page_name

    when /^the home\s?page$/
      '/'
    when /^the create item\s?page$/i
      new_item_path
    when /^the item info page for (.*)/
      item_path(Item.find_by_name($1))
    when /^the edit page for item with id (.*)$/i
      edit_item_path(Item.find_by_id($1))
    when /^the Calteach inventory page/
      items_path
    when /^the user dashboard/
      admin_users_path
    when /^the reservation dashboard/
      admin_reservations_path
    when /^the checkout page for (.*)/
      checkout_item_path(Item.find_by_name($1))
    when /^the edit user page for "(.*)"/
      edit_user_registration_path(User.find_by_name($1))

    # Add more mappings here.
    # Here is an example that pulls values out of the Regexp:
    #
    #   when /^(.*)'s profile page$/i
    #     user_profile_path(User.find_by_login($1))

    else
      begin
        page_name =~ /^the (.*) page$/
        path_components = $1.split(/\s+/)
        self.send(path_components.push('path').join('_').to_sym)
      rescue NoMethodError, ArgumentError
        raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
          "Now, go and add a mapping in #{__FILE__}"
      end
    end
  end
end

World(NavigationHelpers)
