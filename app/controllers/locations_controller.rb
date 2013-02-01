class LocationsController < ApplicationController

  def index
    @counties = County.all(:order => :name)
    @categories = Category.all(:order=>:name)
    @languages = Language.all
    @services = Service.all(:order=>:name)
    params[:miles] = 10 if params[:miles].blank? || params[:miles] == 'Distance'      
    
    locations = Location.all
    @locations = locations.sort_by(&:org_name)
    
    if params[:address].present?
      address = params[:address]
      # box = Geocoder::Calculations.bounding_box([37.816148,-122.267757], 100)
      # @locations = Location.near(address, params[:miles]).within_bounding_box(box)
      @locations = Location.near(address, params[:miles])
      @address = params[:address]
      @results_count = "#{@locations.size} results within #{params[:miles]} miles of #{@address}"
    else
      locations = Location.all
      @locations = locations.sort_by(&:org_name)
      @address = "Your Address"
      @results_count = "#{@locations.size} results"
    end
    
    @json = @locations.to_gmaps4rails
    
    respond_to do |format|
      format.html # index.html.erb
    end
  end
  
  def show
    @location = Location.find(params[:id])
    @organization = @location.organization
    @json = @location.to_gmaps4rails

    respond_to do |format|
      format.html # show.html.erb
    end
  end
    
end
