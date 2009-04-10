class UsersController < ApplicationController
 
 layout "social_life"
 before_filter :login_required, :only=>[:edit, :update, :show_password_form]

  # render new.rhtml
  def new
    @user = User.new
  end
 
  def create
    logout_keeping_session!
    @user = User.new(params[:user])
    success = @user && @user.save
    if success && @user.errors.empty?
            # Protects against session fixation attacks, causes request forgery
      # protection if visitor resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset session
      self.current_user = @user # !! now logged in
      redirect_back_or_default('/')
      flash[:notice] = "Thanks for signing up!  We're sending you an email with your activation code."
    else
      flash[:error]  = "We couldn't set up that account, sorry.  Please try again, or contact an admin (link is above)."
      render :action => 'new'
    end
  end
  
  def edit
    raise "don't edit other people's shit please" unless params[:id] != current_user.id
    @user = User.find(params[:id])
    respond_to do |format|
      format.html # edit.html.erb
      format.js  { render :partial=>"users/edit" }
    end
  end
  
  def update
    raise "don't edit other people's shit please" unless params[:id] != current_user.id
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:notice] = 'Contact was successfully updated.'
        format.html { redirect_to root_path }
        # format.js  { render :partial => "users/details"}
      else
        format.html { render :action => "edit" }
        format.js  { render :partial => "users/edit" }
      end
    end
  end
  
  def show_password_form
    raise "don't edit other people's shit please" unless params[:user_id] != current_user.id
    @user = User.find(params[:user_id])
    respond_to do |format|
        format.js  { render :partial => "users/password_form" }
    end
  end
  
  
end
