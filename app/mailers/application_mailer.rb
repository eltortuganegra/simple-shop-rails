class ApplicationMailer < ActionMailer::Base
  default from: Rails.configuration.x.notificationEmail
  layout 'mailer'
end
