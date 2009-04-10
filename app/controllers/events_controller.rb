class EventsController < ApplicationController 
  layout "standard"
  before_filter :login_required, :except=>:public
  skip_before_filter :verify_authenticity_token, :only => [:auto_complete_for_contact_email]
  auto_complete_for :contact, :email

  def index
    @events = Event.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @events }
    end
  end

  # GET /events/1
  # GET /events/1.xml
  def show
    @event = Event.find(params[:id])
    respond_to do |format|
      format.html {}
    end
  end
  
  def public
    @event = Event.find(params[:event_id])

    respond_to do |format|
      format.html {render :template =>"events/public", :layout=>"social_life"}
      format.xml  { render :xml => @event }
    end
  end

  # GET /events/new
  # GET /events/new.xml
  def new
    @event = Event.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @event }
    end
  end

  # GET /events/1/edit
  def edit
    @event = Event.find(params[:id])
  end

  # POST /events
  # POST /events.xml
  def create
    
    # save file with _id
    # want to get an id then save the file
    # so we need to get the filename, save the record with the filename
    # then save the file with the right filename with _id
    
    @file = params[:event][:picture_location]
    params[:event][:picture_location] = nil
    @event = Event.new(params[:event])
    
    respond_to do |format|
      if @event.save
        @event.save_file(@file)
        flash[:notice] = 'Event was successfully created.'
        format.html { redirect_to(@event) }
        format.xml  { render :xml => @event, :status => :created, :location => @event }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /events/1
  # PUT /events/1.xml
  def update
    @event = Event.find(params[:id])
    if params[:event][:picture_location].kind_of? ActionController::UploadedStringIO
      @file = params[:event][:picture_location]
      File.open("#{RAILS_ROOT}/public/events/#{@file.original_filename}", "wb"){|f| f.write @file.read}
      params[:event][:picture_location] = "/events/#{@file.original_filename}"
    else  
      params[:event][:picture_location] = @event.picture_location
    end
    respond_to do |format|
      if @event.update_attributes(params[:event])
        flash[:notice] = 'Event was successfully updated.'
        format.html { redirect_to(@event) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.xml
  def destroy
    @event = Event.find(params[:id])
    @event.destroy

    respond_to do |format|
      format.html { redirect_to(events_url) }
      format.xml  { head :ok }
    end
  end
  
  def setup_email
    @event = Event.find(params[:event_id])  
  end
  
  def blast_email
    event = Event.find(params[:event_id])
    contacts = Contact.find(params[:contact_ids].split(", "))
    emails = contacts.collect{|c| c.email}
    spawn do
      emails.uniq.each do |email|
        logger.info "=="*45
        logger.info "sending email to: #{email}"
        logger.info "=="*45
        PartyBus.deliver_invitation(email, event)
      end
    end
    redirect_to event_path(event)
  end
  
end
