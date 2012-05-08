class LocationsController < ApplicationController
  
  def index
    @counties = County.all(:order => :name)
    @categories = Category.all(:order=>:name)
    @services = Service.all(:order=>:name)
    params[:miles] = 10 if params[:miles].blank? || params[:miles] == 'Distance'  
    
    if params[:address].present?
      @locations = Location.near(params[:address], params[:miles])
    else
      @locations = Location.all(:order => :name)
    end
    
    session[:county_ids]    = County.all.collect {|x| x.id}
    session[:category_ids]  = Category.all.collect {|x| x.id}
    session[:service_ids]   = Service.all.collect {|x| x.id}
    
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
  
  ####### javascript functions #######

  def show_county
    @county = County.find(params[:county_id])
    
    session[:county_ids] << @county.id unless session[:county_ids].include?(@county.id)
    
    @location_ids = @county.locations.collect {|x| x.id}.try(:flatten).try(:uniq)
        
    respond_to do |format|
      format.js
    end
  end
  
  def hide_county
    @county = County.find(params[:county_id])
    
    session[:county_ids].delete(@county.id)
    
    # find the locations associated with this county, which we want to hide
    county_location_ids = @county.locations.collect {|x| x.id}.try(:uniq)
    
    # find the locations that are associated to the counties in the session, which we want to keep
    session_location_ids = []
    County.where('id IN (?)', session[:county_ids]).each do |county|
      session_location_ids << county.locations.collect {|x| x.id}
    end
    session_location_ids.try(:flatten!).try(:uniq!)
    
    @location_ids = county_location_ids - session_location_ids

    logger.info "-------------- don't hide these ids #{session_location_ids}"
    logger.info "-------------- hiding location ids #{@location_ids}"
    
    respond_to do |format|
      format.js
    end
  end
  
  def show_category
    @category = Category.find(params[:category_id])
    
    session[:category_ids] << @category.id unless session[:category_ids].include?(@category.id)

    @category.services.each {|x| session[:service_ids] << x.id}
    
    @location_ids = @category.locations.collect {|x| x.id}.try(:flatten).try(:uniq)
        
    respond_to do |format|
      format.js
    end
  end
  
  def hide_category
    @category = Category.find(params[:category_id])
    
    session[:category_ids].delete(@category.id)
    @category.services.each {|x| session[:service_ids].delete(x.id)}
    
    # find the locations associated with this category, which we want to hide
    category_location_ids = @category.locations.collect {|x| x.id}.try(:uniq)
    
    # find the locations that are associated to the categories in the session, which we want to keep
    session_location_ids = []
    Category.where('id IN (?)', session[:category_ids]).each do |cat|
      session_location_ids << cat.locations.collect {|x| x.id}
    end
    session_location_ids.try(:flatten!).try(:uniq!)
    
    @location_ids = category_location_ids - session_location_ids

    logger.info "-------------- don't hide these ids #{session_location_ids}"
    logger.info "-------------- hiding location ids #{@location_ids}"
    
    respond_to do |format|
      format.js
    end
  end
  
  def show_service
    @service = Service.find(params[:service_id])
    
    session[:service_ids] << @service.id unless session[:service_ids].include?(@service.id)
    
    @location_ids = @service.locations.collect {|x| x.id}.try(:flatten).try(:uniq)
    
    logger.info "-------------- showing location_ids #{@location_ids}"
    
    respond_to do |format|
      format.js
    end
  end
  
  def hide_service
    @service = Service.find(params[:service_id])
    
    session[:service_ids].delete(@service.id)
    
    # find the locations associated with this service, which we want to hide
    service_location_ids = @service.locations.collect {|x| x.id}.try(:uniq)
    
    # find the locations that are associated to the services in the session, which we want to keep
    session_location_ids = []
    Service.where('id IN (?)', session[:service_ids]).each do |service|
      session_location_ids << service.locations.collect {|x| x.id}
    end
    session_location_ids.try(:flatten!).try(:uniq!)
    
    @location_ids = service_location_ids - session_location_ids
    
    logger.info "-------------- service_ids in the session #{session[:service_ids]}"
    logger.info "-------------- don't hide these location_ids #{session_location_ids}"
    logger.info "-------------- hiding location_ids #{@location_ids}"
    
    respond_to do |format|
      format.js
    end
  end
    
end
