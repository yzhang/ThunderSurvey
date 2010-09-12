ActionMailer::Base.smtp_settings = {
  :address              => "thundersurvey.com",
  :port                 => 25,
  :domain               => "thundersurvey.com",
  :user_name            => "noreply@thundersurvey.com",
  :password             => "changeme",
  :authentication       => "login",
  :enable_starttls_auto => true
} 

ActionMailer::Base.default_url_options[:host] = (Rails.env == 'production' ? "www.thundersurvey.com" : "localhost")