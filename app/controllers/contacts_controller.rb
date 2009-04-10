class ContactsController < ApplicationController 
  layout "standard"
  before_filter :login_required
  
  def add_contact
    # need to figure out a good way of adding contacts to a hidden field one at a time and preserving the list
    @errors = []
    @contacts ||= [] << Contact.find_by_email(params[:contact][:email])
    respond_to do |wants|
      wants.html{ raise "you suck stop that."}
      wants.js { render :partial => "contacts/list" }
    end
  end
  
  def bulk_create
    emails = params[:emails].first
    puts emails.class
    puts emails.inspect

    emails = emails.split(",")
    puts "=="*45
    puts emails
    # puts emails.inspect
    puts "=="*45
    emails = emails.uniq.compact
    
    puts emails.inspect
     puts "=="*45
     emails.collect{|email| email.gsub!(/\s/,'')}
     puts emails.inspect
     puts "=="*45
    @contacts = []
    @errors = []
    emails.each do |email|
      c = Contact.find_or_create_by_email(:email=>email) 
      @contacts << c if c.valid?
      @errors << c unless c.valid?
    end
    
    respond_to do |wants|
      wants.html{ raise "you suck stop that."}
      wants.js { render :partial => "contacts/list" }
    end
    
  end
  
  
  def index
    @contacts = Contact.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @contacts }
    end
  end

  # GET /contacts/1
  # GET /contacts/1.xml
  def show
    @contact = Contact.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @contact }
    end
  end

  # GET /contacts/new
  # GET /contacts/new.xml
  def new
    @contact = Contact.new

    respond_to do |format|
      format.html # new.html.erb
      format.js  { render :partial=>"contacts/edit" }
    end
  end

  # GET /contacts/1/edit
  def edit
    @contact = Contact.find(params[:id])
    respond_to do |format|
      format.html # edit.html.erb
      format.js  { render :partial=>"contacts/edit" }
    end
  end

  # POST /contacts
  # POST /contacts.xml
  def create
    @contact = Contact.new(params[:contact])

    respond_to do |format|
      if @contact.save
        flash[:notice] = 'Contact was successfully created.'
        format.html { redirect_to(@contact) }
        format.xml  { render :xml => @contact, :status => :created, :location => @contact }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @contact.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /contacts/1
  # PUT /contacts/1.xml
  def update
    @contact = Contact.find(params[:id])

    respond_to do |format|
      if @contact.update_attributes(params[:contact])
        flash[:notice] = 'Contact was successfully updated.'
        format.html { redirect_to(@contact) }
        format.js  { render :partial => "contacts/details"}
      else
        format.html { render :action => "edit" }
        format.js  { render :partial => "contacts/edit" }
      end
    end
  end

  # DELETE /contacts/1
  # DELETE /contacts/1.xml
  def destroy
    @contact = Contact.find(params[:id])
    @contact.destroy

    respond_to do |format|
      format.html { redirect_to(contacts_url) }
      format.xml  { head :ok }
    end
  end
end
