class Admin::UsersController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource
  layout 'admin'
  before_filter :load_organizations
  
  def index
    @users = User.all(:order => :email)

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def create
    params[:user][:password] = rand(36**8).to_s(36)
    params[:user][:password_confirmation] = params[:user][:password]
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        SignupMailer.invite(@user, params[:user][:password]).deliver
        format.html { redirect_to admin_users_url, notice: 'User was successfully created. Notification email sent.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  def update
    @user = User.find(params[:id])
    email_changed = @user.email != params[:user][:email]
    password_changed = !params[:user][:password].empty?
    successfully_updated = if password_changed
      @user.update_with_password(params[:user])
    else
      @user.update_without_password(params[:user])
    end

    if successfully_updated
      # Sign in the user bypassing validation in case his password changed
      # sign_in @user, :bypass => true
      redirect_to admin_users_url, notice: 'User was successfully updated.' 
    else
      render "edit"
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to admin_users_url, notice: 'User was successfully deleted.' }
    end
  end

  def load_organizations
    @organizations = Organization.all(:order => :name)
  end
end
