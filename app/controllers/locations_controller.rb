class LocationsController < ApplicationController
  
  def index
    @categories = Category.all(:order=>:name)
    @services = Service.all(:order=>:name)
    session[:category_ids] ||= Category.all.collect {|x| x.id}
    session[:service_ids] ||= []
    params[:miles] ||= 10
    
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
    category_location_ids.try(:flatten!).try(:uniq!)
    
    # Address Locations
    
    if params[:address].present?
      logger.info "------------------------------ MILES #{params[:miles]}"
      @locations = Location.where('id IN (?)', category_location_ids).near(params[:address], params[:miles])
    else
      @locations = Location.find(category_location_ids)
    end
        
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
