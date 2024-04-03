class LandingPagePolicy < ApplicationPolicy
  

  def show?
   render("show")
  end

  
end
