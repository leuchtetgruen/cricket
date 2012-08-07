class UsersController < ApplicationController
  before_filter :authorize_as_admin, :except => [:account, :update_password]
  before_filter :authorize, :only => [:account, :update_password]
  
  # GET /users
  # GET /users.json
  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(params[:user])
    @user.salt_and_encrypt!

    respond_to do |format|
      if @user.save
        format.html { redirect_to users_path, notice: 'User was successfully created.' }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = User.find(params[:id])
    
    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully deleted' }
      format.json { head :no_content }
    end
  end
  
  def account
    @user = current_user
    
    respond_to do |format|
      format.html
      format.json { render json: @user }
    end
  end
  
  def update_password
    @user = current_user
    
    data = params[:user]
    if (data[:current_password].empty? or data[:new_password].empty? or data[:new_password_repeat].empty?) then
      redirect_to account_path, alert: "Please fill in all fields"
    elsif !User.authenticates?(@user.name, data[:current_password]) then
      redirect_to account_path, alert: "Please fill in the right current password."
    elsif (data[:new_password] != data[:new_password_repeat]) then
      redirect_to account_path, alert: "The repeated and the original new password did not match"
    else
      @user.password = data[:new_password]
      @user.salt_and_encrypt!
      @user.save
      redirect_to account_path, notice: 'Your password has been reset successfully.'
    end
    
  end
end
