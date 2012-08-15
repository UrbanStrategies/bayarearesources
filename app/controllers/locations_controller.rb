class LocationsController < ApplicationController
  
  def index
    @counties = County.all(:order => :name)
    @categories = Category.all(:order=>:name)
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

    session[:location_ids] = @locations.collect {|x| x.id}
    session[:category_ids] = nil

    # session[:county_ids]      ||= []
    # session[:category_ids]    ||= []
    # session[:service_ids]     ||= []
    # session[:locations_count] ||= @locations.size
    
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
    session[:locations_count] -= @location_ids.size
    
    logger.info "-------------- don't hide these ids #{session_location_ids}"
    logger.info "-------------- hiding location ids #{@location_ids}"
    
    respond_to do |format|
      format.js
    end
  end
  
  def show_category
    @category = Category.find(params[:category_id])

    if session[:category_ids].blank?
      session[:category_ids] = []
    end    

    session[:category_ids] << @category.id unless session[:category_ids].include?(@category.id)

    @category.services.each {|x| session[:service_ids] << x.id}
    
    @location_ids = @category.locations.collect {|x| x.id}.try(:flatten).try(:uniq)
    @hidden_location_ids = Location.all.collect {|x| x.id } - Category.find(session[:category_ids]).collect {|category| category.locations.collect {|x| x.id}}.flatten.uniq
    session[:locations_count] += @location_ids.size
        
    respond_to do |format|
      format.js
    end
  end
    
end
