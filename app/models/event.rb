class Event < ActiveRecord::Base
  belongs_to :location

   def save_file(file)   
      File.open("#{RAILS_ROOT}/public/events/#{self.id}_#{file.original_filename}", "wb"){|f| f.write file.read}
      self.picture_location = "/events/#{self.id}_#{file.original_filename}"
      self.save
   end
   
   def image
     self.picture_location || "/images/no_pic.jpg"
   end
end
