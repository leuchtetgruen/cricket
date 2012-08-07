class IssuesController < ApplicationController
  before_filter :authorize, :except => [:new, :create, :index, :show]

  
  # GET /issues
  # GET /issues.json
  def index
    if (!new_filter(params)) then
      @filter_params = session[:issues_filter] if session[:issues_filter]
    else
      @filter_params = params
      session[:issues_filter] = @filter_params
    end
    
    @issues     = issues_by_params(@filter_params)
    @softwares  = Software.all.map { |s| [s.title, s.id]}
    @users      = User.all.map { |u| [u.name, u.id]}
    
    @title      = title_by_params(@filter_params)
    @software   = Software.find(@filter_params[:software]) if (@filter_params and @filter_params[:software] and !@filter_params[:software].empty?)
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @issues }
    end
  end

  # GET /issues/1
  # GET /issues/1.json
  def show
    @issue = Issue.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @issue }
    end
  end

  # GET /issues/new
  # GET /issues/new.json
  def new
    @issue = Issue.new
    if params[:software] then
      @hide_software_field  = true
      @issue.software_id    = params[:software]
      @issue.software       = Software.find(@issue.software_id)
    end

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @issue }
    end
  end

  # GET /issues/1/edit
  def edit
    @issue = Issue.find(params[:id])
  end

  # POST /issues
  # POST /issues.json
  def create
    @issue = Issue.new(params[:issue])

    respond_to do |format|
      if (current_user or verify_recaptcha(:model => @issue, :message => 'Please reenter the captcha')) && @issue.save
        format.html { redirect_to issues_path, notice: 'Issue was successfully reported.' }
        format.json { render json: @issue, status: :created, location: @issue }
      else
        format.html { render action: "new" }
        format.json { render json: @issue.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /issues/1
  # PUT /issues/1.json
  def update
    @issue = Issue.find(params[:id])
    
    p = params[:issue]

    Message.create(:user => current_user, :issue => @issue, :text => "Changed type to #{Issue.type_with_id(p[:type].to_i)}") if p[:type] != @issue.type
    Message.create(:user => current_user, :issue => @issue, :text => "Assigned to #{User.find(p[:user])}") if (p[:user] != @issue.user_id) and p[:user]

    respond_to do |format|
      if @issue.update_attributes(params[:issue])
        format.html { redirect_to issues_path, notice: 'Issue was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @issue.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /issues/1
  # DELETE /issues/1.json
  def destroy
    @issue = Issue.find(params[:id])
    @issue.destroy

    respond_to do |format|
      format.html { redirect_to issues_url }
      format.json { head :no_content }
    end
  end
  
  def resolve
    @issue = Issue.find(params[:id])
    @issue.resolved = true
    @issue.save
    
    
    Message.create(:user => current_user, :issue => @issue, :text => "Resolved : #{params[:text]}")
    
    respond_to do |format|
      format.html { redirect_to issues_url, notice: 'The issue has been resolved.' }
      format.json { head :no_content }
    end
  end
  
  def reopen
    @issue = Issue.find(params[:id])
    @issue.resolved = false
    @issue.save
    
    Message.create(:user => current_user, :issue => @issue, :text => "Reopened : #{params[:text]}")    
    
    respond_to do |format|
      format.html { redirect_to issues_url, notice: 'The issue has been reopened.' }
      format.json { head :no_content }
    end
  end
  
  def reset_filter
    session[:issues_filter] = nil
    respond_to do |format|
      format.html { redirect_to issues_url }
      format.json { head :no_content }
    end
  end
  
  protected
    def issues_by_params(filter_params)
      
      conditions = {}
      if filter_params then
        conditions[:software_id] = filter_params[:software] if (filter_params[:software] and !filter_params[:software].empty?)
        conditions[:resolved] = false if (filter_params[:status] and filter_params[:status] == "unresolved")
        conditions[:resolved] = true if (filter_params[:status] and filter_params[:status] == "resolved")
        conditions[:user_id] = filter_params[:user] if (filter_params[:user] and !filter_params[:user].empty?)
        conditions[:user_id] = nil if filter_params[:unassigned]
        conditions[:type] = filter_params[:type] if (filter_params[:type] and !filter_params[:type].empty?)
      end

      set = []
      
      if filter_params and filter_params[:order_by] then
        asc_desc = (filter_params[:order] or "asc").upcase
        order = "#{filter_params[:order_by]} #{asc_desc}"      
        if conditions.empty? then
          set = Issue.paginate(:page => params[:page]).order(order)
        else
          set = Issue.where(conditions).paginate(:page => params[:page]).order(order)
        end
      else
        if conditions.empty? then
          set = Issue.paginate(:page => params[:page]).order("created_at DESC")
        else
          set = Issue.where(conditions).paginate(:page => params[:page]).order("created_at DESC")
        end
      end

      return set
    end
    
    def title_by_params(params)
      if params then
        text    = 'Issues'        
        text   += " for #{Software.find(params[:software])}" if (params[:software] and !params[:software].empty?)
        
        text
      else
        'Issues'
      end
    end
    
    def new_filter(params)
      [:software, :status, :user, :unassigned, :type].any? do |param|
        params.keys.include? param.to_s
      end
    end
    

end
