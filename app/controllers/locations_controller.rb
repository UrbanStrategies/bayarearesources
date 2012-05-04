class LocationsController < ApplicationController
  
  def index
    @categories = Category.all(:order=>:name)
    @services = Service.all(:order=>:name)
    session[:category_ids] ||= []
    session[:service_ids] ||= []
    
    # Address Locations
    
    if params[:address].present?
      @address_placehoder = params[:address]
      session[:address] = params[:address]
      address_locations = Location.near(session[:address], 100)
      address_locations.present? ? location_ids = address_locations.collect {|x| x.id} : location_ids = []
    else
      @address_placehoder = 'Your Address' 
      session[:address] = nil
      location_ids = Location.all.collect {|x| x.id}
    end
      
    # Category Locations
    
    if params[:add_category].present?
      session[:category_ids] << params[:add_category].to_i
    elsif params[:remove_category].present?
      session[:category_ids].delete(params[:remove_category].to_i)
    end
    
    category_location_ids = []
    session[:category_ids].each do |cat_id|
      category_location_ids << Category.find(cat_id).locations.collect {|x| x.id}
    end
    location_ids = location_ids & category_location_ids.flatten
    
    @locations = Location.find(location_ids)
    @json = @locations.to_gmaps4rails
    
    respond_to do |format|
      format.html # index.html.erb
      format.js {render :content_type => 'text/javascript'}
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
