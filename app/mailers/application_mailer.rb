class ApplicationMailer < ActionMailer::Base
  default from: ENV['APP_MAILER_SENDER'] || 'support@courses.paranabuka.com'
  layout 'mailer'
end
