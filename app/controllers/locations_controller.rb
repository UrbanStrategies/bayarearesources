class LocationsController < ApplicationController
  
  def index
    @categories = Category.all(:order=>:name)
    if params[:address].present?
      @locations = Location.near(params[:address], 100)
      @address_placehoder = params[:address]
    else
      @locations = Location.all
      @address_placehoder = 'Address City, State'
    end
    
    @json = @locations.to_gmaps4rails
    
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def show
    @location = Location.find(params[:id])
    @json = @location.to_gmaps4rails

    respond_to do |format|
      format.html # show.html.erb
    end
  end
end
