class UsersController < ApplicationController
  def show
    @user = User.find_by(username: params.fetch(:username))
    @listings = Listing.all.order(:created_at => :desc)
  end
end
