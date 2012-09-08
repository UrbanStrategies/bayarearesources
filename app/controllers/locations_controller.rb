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
  
  def hide_locations
    if params[:language_id].present?
      @language = Language.find(params[:language_id])
      session[:language_ids].delete(params[:language_id])
      # find the locations associated with this language, which we want to hide
      language_location_ids_to_hide = @language.locations.collect {|x| x.id}
    end
    
    if params[:category_id].present?
      @category = Category.find(params[:category_id])
      session[:category_ids].delete(params[:category_id])
      # find the locations associated with this category, which we want to hide
      category_location_ids_to_hide = @category.locations.collect {|x| x.id}
    end
  
    # find the locations that are associated to the languages in the session, which we want to keep
    session_location_ids = []
    language_location_ids_to_hide ||= []
    category_location_ids_to_hide ||= []
    
    Language.where('id IN (?)', session[:language_ids]).each do |lang|
      session_location_ids << lang.locations.collect {|x| x.id}
    end
    Category.where('id IN (?)', session[:category_ids]).each do |cat|
      session_location_ids << cat.locations.collect {|x| x.id}
    end
    
    @location_ids_to_hide = (language_location_ids_to_hide + category_location_ids_to_hide).flatten.uniq - session_location_ids.flatten.uniq
    
    # logger.info "-------------- don't hide these ids #{session_location_ids}"
    # logger.info "-------------- hiding location ids #{@location_ids_to_hide}"
    
    respond_to do |format|
      format.js
    end
  end
  
  def show_locations
    @language = Language.find(params[:language_id]) if params[:language_id].present?
    @category = Category.find(params[:category_id]) if params[:category_id].present?

    session[:category_ids] = [] if session[:category_ids].blank?
    session[:language_ids] = [] if session[:language_ids].blank?
    session[:category_ids] << params[:category_id] unless @category.blank?
    session[:language_ids] << params[:language_id] unless @language.blank?
    session[:category_ids].uniq!
    session[:language_ids].uniq!
    
    @location_ids_to_show = @language.locations.collect {|x| x.id} if @language.present?
    @location_ids_to_show = @category.locations.collect {|x| x.id} if @category.present?
        
    @location_ids_to_hide = Location.all.collect {|x| x.id } - (Language.find(session[:language_ids]).collect {|language| language.locations.collect {|x| x.id}} + Category.find(session[:category_ids]).collect {|category| category.locations.collect {|x| x.id}}).flatten.uniq
    
    logger.info "-------------- showing location ids #{@location_ids_to_show}"
    logger.info "-------------- hiding location ids #{@location_ids_to_hide}"
    
        
    respond_to do |format|
      format.js
    end
  end
    
end
