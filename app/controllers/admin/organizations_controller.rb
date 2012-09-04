class Admin::OrganizationsController < ApplicationController
  layout 'admin'
  before_filter :authenticate_user!
  load_and_authorize_resource
    
  def index
    @organizations = Organization.all(:order => :name)

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def show
    @organization = Organization.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def new
    @organization = Organization.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  def edit
    @organization = Organization.find(params[:id])
  end

  def create
    @organization = Organization.new(params[:organization])
    @languages = []
    if params[:languages].present?
      params[:languages].each do |s|
        @languages << Language.find(s[0].to_i)
      end
    end
    
    respond_to do |format|
      if @organization.save
        if @languages.present?
          @organization.languages.delete_all
          @organization.languages << @languages
        end
        format.html { redirect_to admin_organizations_url, notice: 'Organization was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  def update
    @organization = Organization.find(params[:id])
    @languages = []
    if params[:languages].present?
      params[:languages].each do |s|
        @languages << Language.find(s[0].to_i)
      end
    end
    
    respond_to do |format|
      if @organization.update_attributes(params[:organization])
        if @languages.present?
          @organization.languages.delete_all
          @organization.languages << @languages
        end
        format.html { redirect_to admin_organizations_url, notice: 'Organization was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    @organization = Organization.find(params[:id])
    @organization.destroy

    respond_to do |format|
      format.html { redirect_to admin_organizations_url }
    end
  end
end
