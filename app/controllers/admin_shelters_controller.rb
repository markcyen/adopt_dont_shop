class AdminSheltersController < ApplicationController
  def index
    @shelters = Shelter.reverse_alphabetical
    @applications = Application.all
  end
end
