class LocationsController < ApplicationController

  def index
    @counties = County.all(:order => :name)
    @categories = Category.all(:order=>:name)
    @languages = Language.all
    @services = Service.all(:order=>:name)
    params[:miles] = 10 if params[:miles].blank? || params[:miles] == 'Distance'      
    
    locations = Location.all
    @locations = locations.sort_by(&:org_name)
    
    @results_count = "#{@locations.size} results"
    
    @json = @locations.to_gmaps4rails
    
    respond_to do |format|
      format.html # index.html.erb
    end
  end
  
  def address_search
    @counties = County.all(:order => :name)
    @categories = Category.all(:order=>:name)
    @languages = Language.all
    @services = Service.all(:order=>:name)
    
    params[:miles] = 10 if params[:miles].blank? || params[:miles] == 'Distance'  

    if params[:address].present?
      @locations = Location.near(params[:address], params[:miles])
      @address = params[:address]
    else
      locations = Location.all
      @locations = locations.sort_by(&:org_name)
      @address = "Your Address"
    end
    
    @results_count = "#{@locations.size} results within #{params[:miles]} miles of #{@address}"
    
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
