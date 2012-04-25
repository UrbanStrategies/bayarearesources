class LocationsController < ApplicationController
  
  def index
    if params[:address].present?
      @locations = Location.near(params[:address], 100)
      @address_placehoder = params[:address]
    else
      @locations = Location.all
      @address_placehoder = 'Address City, State'
    end
    
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
end
