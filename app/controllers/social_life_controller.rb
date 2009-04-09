class SocialLifeController < ApplicationController
  
  def index
    @event = Event.first :order=>"created_at ASC"
  end
  
end
