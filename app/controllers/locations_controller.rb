class LocationsController < ApplicationController

  def index
    @counties = County.all(:order => :name)
    @categories = Category.all(:order=>:name)
    @languages = Language.all(:order=>:name)
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
    
    @results_count = "#{@locations.size} Results"

    session[:location_ids] = @locations.collect {|x| x.id}
    session[:language_ids] = []
    session[:category_ids] = []
    
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
