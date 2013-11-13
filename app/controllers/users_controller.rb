class UsersController < ApplicationController

  def reservations
    @reservations = current_user.reservations
  end

end
