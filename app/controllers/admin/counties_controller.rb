class Admin::CountiesController < ApplicationController
  layout 'admin'
  before_filter :authenticate_user!

  def index
    @counties = County.all(:order => :name)

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def show
    @county = County.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def new
    @county = County.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  def edit
    @county = County.find(params[:id])
  end

  def create
    @county = County.new(params[:county])

    respond_to do |format|
      if @county.save
        format.html { redirect_to admin_counties_url, notice: 'County was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  def update
    @county = County.find(params[:id])

    respond_to do |format|
      if @county.update_attributes(params[:county])
        format.html { redirect_to admin_counties_url, notice: 'County was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    @county = County.find(params[:id])
    @county.destroy

    respond_to do |format|
      format.html { redirect_to admin_counties_url }
    end
  end
end
