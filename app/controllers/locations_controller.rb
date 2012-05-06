class LocationsController < ApplicationController
  
  def index
    @categories = Category.all(:order=>:name)
    @services = Service.all(:order=>:name)
    params[:miles] = 10 if params[:miles].blank? || params[:miles] == 'Distance'  
    
    if params[:address].present?
      @locations = Location.near(params[:address], params[:miles])
    else
      @locations = Location.all(:order => :name)
    end
    
    session[:category_ids] = Category.all.collect {|x| x.id}
    
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
    
    @location_ids = Category.find(params[:category_id]).locations.collect {|x| x.id}.try(:flatten).try(:uniq)
    
    logger.info "-------------- showing location ids #{@location_ids}"
    
    respond_to do |format|
      format.js
    end
  end
  
  def hide_category
    session[:category_ids].delete(params[:category_id].to_i)
    
    category_location_ids = Category.find(params[:category_id]).locations.collect {|x| x.id}.try(:uniq)
    
    session_location_ids = []
    Category.where('id IN (?)', session[:category_ids]).each do |cat|
      session_location_ids << cat.locations.collect {|x| x.id}
    end
    session_location_ids.try(:flatten!).try(:uniq!)
    
    logger.info "-------------- don't hide these ids #{session_location_ids}"
    
    @location_ids = category_location_ids - session_location_ids
    logger.info "-------------- hiding location ids #{@location_ids}"
    
    respond_to do |format|
      format.js
    end
  end
    
end
