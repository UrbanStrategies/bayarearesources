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

    session[:location_ids] = @locations.collect {|x| x.id}
    session[:language_ids] = nil
    session[:category_ids] = nil
    
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
  
  ####### javascript functions #######
  
  def hide_category
    @category = Category.find(params[:category_id])
    
    # remove the category_id from the session
    session[:category_ids].delete(@category.id)
    
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
  
  def show_category
    @category = Category.find(params[:category_id])

    if session[:category_ids].blank?
      session[:category_ids] = []
    end    

    session[:category_ids] << @category.id unless session[:category_ids].include?(@category.id)
    
    @location_ids = @category.locations.collect {|x| x.id}.try(:flatten).try(:uniq)
    @hidden_location_ids = Location.all.collect {|x| x.id } - Category.find(session[:category_ids]).collect {|category| category.locations.collect {|x| x.id}}.flatten.uniq
        
    respond_to do |format|
      format.js
    end
  end
  
  def hide_language
    @language = Language.find(params[:language_id])
    
    # hide the language from the session
    session[:language_ids].delete(@language.id)
    
    # find the locations associated with this language, which we want to hide
    language_location_ids = @language.locations.collect {|x| x.id}
    
    # find the locations that are associated to the categories in the session, which we want to keep
    session_location_ids = []
    Language.where('id IN (?)', session[:language_ids]).each do |lang|
      session_location_ids << lang.locations.collect {|x| x.id}
    end
    session_location_ids.try(:flatten!).try(:uniq!)
    
    @location_ids = language_location_ids - session_location_ids
    
    logger.info "-------------- don't hide these ids #{session_location_ids}"
    logger.info "-------------- hiding location ids #{@location_ids}"
    
    respond_to do |format|
      format.js
    end
  end
  
  def show_language
    @language = Language.find(params[:language_id])

    if session[:language_ids].blank?
      session[:language_ids] = []
    end    

    session[:language_ids] << @language.id unless session[:language_ids].include?(@language.id)
    
    @location_ids = @language.locations.collect {|x| x.id}
    @hidden_location_ids = Location.all.collect {|x| x.id } - Language.find(session[:language_ids]).collect {|language| language.locations.collect {|x| x.id}}.flatten.uniq
        
    respond_to do |format|
      format.js
    end
  end
    
end
