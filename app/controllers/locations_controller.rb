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
  
  ####### javascript functions #######
  
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
    
    # determine the overlap
    
    @location_ids_to_show = session_location_ids.flatten.uniq
    @location_ids_to_hide = (language_location_ids_to_hide + category_location_ids_to_hide).flatten.uniq - @location_ids_to_show
    if @location_ids_to_show.try(:size) == 0
      @results_count = "Sorry, there are no results for that search"
    else
      @results_count = "#{@location_ids_to_show.try(:size)} Results"
    end
      
    # logger.info "-------------- don't hide these ids #{session_location_ids}"
    # logger.info "-------------- hiding location ids #{@location_ids_to_hide}"
    
    respond_to do |format|
      format.js
    end
  end
  
  def show_locations
    @language = Language.find(params[:language_id]) if params[:language_id].present?
    @category = Category.find(params[:category_id]) if params[:category_id].present?

    session[:category_ids] << params[:category_id] unless @category.blank?
    session[:language_ids] << params[:language_id] unless @language.blank?
    session[:category_ids].uniq!
    session[:language_ids].uniq!
    
    language_locations = Language.where(id: session[:language_ids]).map {|language| language.locations.map {|x| x.id}}.inject(:&)
    category_locations = Category.where(id: session[:category_ids]).map {|category| category.locations.map {|x| x.id}}.inject(:&)
    
    if language_locations.blank? && category_locations.blank?
      combined_location_ids = []
    elsif language_locations.present? && category_locations.present?
      combined_location_ids = (language_locations & category_locations)
    elsif language_locations.present?
      combined_location_ids = language_locations
    elsif category_locations.present?
      combined_location_ids = category_locations
    end
    
    @location_ids_to_show = combined_location_ids
    @location_ids_to_hide = Location.all.collect {|x| x.id } - combined_location_ids
    if @location_ids_to_show.try(:size) == 0
      @results_count = "Sorry, there are no results for that search"
    else
      @results_count = "#{@location_ids_to_show.try(:size)} Results"
    end
    
    logger.info "-------------- showing location ids #{@location_ids_to_show}"
    logger.info "-------------- hiding location ids #{@location_ids_to_hide}"
    
    respond_to do |format|
      format.js
    end
  end
    
end
