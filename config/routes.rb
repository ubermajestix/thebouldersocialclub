ActionController::Routing::Routes.draw do |map|

  map.resources :users
  map.resource :session
  map.resources :ticket_types
  map.resources :contacts
  map.resources :locations
  map.resources :users
  map.resources :events
  
  # Event Routes
  map.public_event "/events/public/:event_id", :controller=>'events', :action=>'public'
  map.setup_event_email '/events/email/setup/:event_id', :controller=>'events', :action=>'setup_email'
  map.email_event "/events/email/:event_id", :controller=>'events', :action=>'blast_email'
 
  # Contact Routes
  map.bulk_create_contacts "/contacts/bulk_create", :controller=>'contacts', :action=>'bulk_create'
  map.update_contact "/contacts/update/:id", :controller=>"contacts", :action=>"update"
  map.add_contact "/contacts/add/:id", :controller=>"contacts", :action=>"add_contact"
  map.auto_complete ':controller/:action', 
                    :requirements => { :action => /auto_complete_for_\S+/ },
                    :conditions => { :method => :get }
  # User Routes
  map.show_password_form "/users/password_form/:user_id", :controller => 'users', :action => 'show_password_form'
  
  # Session Routes
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.register '/register', :controller => 'users', :action => 'create'
  map.signup '/super_secret_signup_page', :controller => 'users', :action => 'new'
  
  # Default Routes
  map.root :controller => "social_life"
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
