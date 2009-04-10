class Location < ActiveRecord::Base
  has_many :events
  require 'cgi'
  def map_src
    "http://maps.google.com/maps?hl=en&amp;geocode=&amp;q=#{cgi_address}&amp;z=15&amp;output=embed"
  end
  
  def cgi_address
    CGI.escape(street_address + "+"+zip)
  end
  
  def gmap
   " <iframe width=\"425\" height=\"350\" 
  				 frameborder=\"0\" scrolling=\"no\" marginheight=\"0\" marginwidth=\"0\" 
  				src=\"#{map_src}\">
  				</iframe><br />
  	<small><a href=\"#{map_src}\">view larger map</a>		</small>"
  end
  
end
