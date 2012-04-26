class Admin::ServicesController < ApplicationController
  layout 'admin'
  before_filter :authenticate_user!
  before_filter :load_variables
  
  def index
    @services = Service.all(:order=>:name)

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
  
  private
  def load_variables
    @categories = Category.all(:order=>:name)
  end
end
