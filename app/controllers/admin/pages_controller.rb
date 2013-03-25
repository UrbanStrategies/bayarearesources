class Admin::PagesController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource
  layout 'admin'
    
  def index
    @pages = Page.all(:order => :name)

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def show
    @page = Page.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def new
    @page = Page.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  def edit
    @page = Page.find(params[:id])
  end

  def create
    @page = Page.new(params[:page])
    
    respond_to do |format|
      if @page.save
        format.html { redirect_to admin_pages_url, notice: 'Page was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  def update
    @page = Page.find(params[:id])
    
    respond_to do |format|
      if @page.update_attributes(params[:page])
        format.html { redirect_to admin_pages_url, notice: 'Page was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    @page = Page.find(params[:id])
    @page.destroy

    respond_to do |format|
      format.html { redirect_to admin_pages_url }
    end
  end
end
