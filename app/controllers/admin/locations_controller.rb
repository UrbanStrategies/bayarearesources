class Admin::LocationsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource
  before_filter :load_variables
  layout 'admin'
  
  def index
    @locations = @organization.locations

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def show
    @location = Location.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def new
    @location = Location.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  def edit
    @location = Location.find(params[:id])
  end

  def create
    @location = Location.new(params[:location])
    @location.organization = @organization
    
    @services = []    
    if params[:services].present?
      params[:services].each do |s|
        @services << Service.find(s[0].to_i)
      end
    end
    
    @languages = []
    if params[:languages].present?
      params[:languages].each do |l|
        @languages << Language.find(l[0].to_i)
      end
    end
    
    @service_delivery_options = []
    if params[:service_delivery_options].present?
      params[:service_delivery_options].each do |s|
        @service_delivery_options << ServiceDeliveryOption.find(s[0].to_i)
      end
    end

    respond_to do |format|
      if @location.save
        if @services.present?
          @location.services.delete_all
          @location.services << @services
        end
        if @languages.present?
          @organization.languages.delete_all
          @organization.languages << @languages
        end
        if @service_delivery_options.present?
          @location.service_delivery_options.delete_all
          @location.service_delivery_options << @service_delivery_options
        end
        format.html { redirect_to admin_organization_locations_url(@organization), notice: 'Location was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  def update
    @location = Location.find(params[:id])
    params[:location][:organization_id] = @organization.id
    
    @services = []    
    if params[:services].present?
      params[:services].each do |s|
        @services << Service.find(s[0].to_i)
      end
    end
    
    @languages = []
    if params[:languages].present?
      params[:languages].each do |l|
        @languages << Language.find(l[0].to_i)
      end
    end
    
    @service_delivery_options = []
    if params[:service_delivery_options].present?
      params[:service_delivery_options].each do |s|
        @service_delivery_options << ServiceDeliveryOption.find(s[0].to_i)
      end
    end
    
    respond_to do |format|
      if @location.update_attributes(params[:location])
        if @services.present?
          @location.services.delete_all
          @location.services << @services
        end
        if @languages.present?
          @organization.languages.delete_all
          @organization.languages << @languages
        end
        if @service_delivery_options.present?
          @location.service_delivery_options.delete_all
          @location.service_delivery_options << @service_delivery_options
        end
        format.html { redirect_to admin_organization_locations_path(@organization), notice: 'Location was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    @location = Location.find(params[:id])
    @location.destroy

    respond_to do |format|
      format.html { redirect_to admin_organization_locations_url(@organization) }
    end
  end
  
  private
  def load_variables
    @organization = Organization.find(params[:organization_id])
    @organizations = Organization.all(:order => :name)
    @services = Service.all(:order => :name)
  end
end
