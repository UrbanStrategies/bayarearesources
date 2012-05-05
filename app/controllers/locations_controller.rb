class LocationsController < ApplicationController
  
  def index
    @categories = Category.all(:order=>:name)
    @services = Service.all(:order=>:name)
    params[:miles] ||= 10
    
    
    if params[:address].present?
      @locations = Location.near(params[:address], params[:miles])
    else
      @locations = Location.all(:order => :name)
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
  
  def show_category
    session[:category_ids] << params[:category_id].to_i
    session[:category_ids].try(:uniq!)
    
    category_location_ids = []
    Category.find(params[:category_id]).locations.each do |location|
      category_location_ids << location.id
    end
    
    @location_ids = category_location_ids.try(:flatten).try(:uniq)
    logger.info "-------------- showing location ids #{@location_ids}"
    
    respond_to do |format|
      format.js
    end
  end
  
  def hide_category
    session[:category_ids].delete(params[:category_id].to_i)
    
    all_location_ids = Location.all.collect {|x| x.id}
    
    session_category_location_ids = []
    session[:category_ids].each do |cat_id|
      session_category_location_ids << Category.find(cat_id).locations.collect {|x| x.id}
    end
    session_category_location_ids.try(:flatten!).try(:uniq!)    
    
    @location_ids = all_location_ids - session_category_location_ids
    logger.info "-------------- hiding location ids #{@location_ids}"
    
    respond_to do |format|
      format.js
    end
  end
    
end
