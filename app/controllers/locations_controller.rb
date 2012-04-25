class LocationsController < ApplicationController
  before_filter :load_variables
  
  def index
    @locations = Location.all

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def show
    @location = Location.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end
  
  private
  def load_variables
    @organization = Organization.find(params[:organization_id])
    @organizations = Organization.all(:order => :name)
    @services = Service.all(:order => :name)
  end
end
