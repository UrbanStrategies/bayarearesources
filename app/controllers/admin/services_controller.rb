class Admin::ServicesController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    @services = Service.all

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def show
    @service = Service.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def new
    @service = Service.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  def edit
    @service = Service.find(params[:id])
  end

  def create
    @service = Service.new(params[:service])

    respond_to do |format|
      if @service.save
        format.html { redirect_to admin_services_url, notice: 'Service was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  def update
    @service = Service.find(params[:id])

    respond_to do |format|
      if @service.update_attributes(params[:service])
        format.html { redirect_to admin_services_url, notice: 'Service was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    @service = Service.find(params[:id])
    @service.destroy

    respond_to do |format|
      format.html { redirect_to admin_services_url }
    end
  end
end
