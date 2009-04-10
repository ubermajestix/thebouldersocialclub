class Contact < ActiveRecord::Base
  
  validates_uniqueness_of   :email
  validates_format_of       :email,    :with => Authentication.email_regex, :message => Authentication.bad_email_message
  
  
  def full_name
    (first_name || '') + " " + (last_name || '')
  end
  
end
