class HomeController < ApplicationController

  def show
    @listings = Listing.all.order(:created_at => :desc)
  end

end
