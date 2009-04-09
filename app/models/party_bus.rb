class PartyBus < ActionMailer::Base
  def invitation(email_address, event)
    recipients    email_address
    subject      "You Are Invited..."
    from         "PartyBus@thebouldersocialclub.com"
    body         :event => event
    content_type "text/html"
  end

end
