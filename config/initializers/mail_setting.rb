ActionMailer::Base.smtp_settings = {
  :address              => "51qiangda.com",
  :port                 => 25,
  :domain               => "51qiangda.com",
  :user_name            => "noreply@51qiangda.com",
  :password             => "tellmewhy",
  :authentication       => "login",
  :enable_starttls_auto => true
} 

ActionMailer::Base.default_url_options[:host] = (Rails.env == 'production' ? "www.51qiangda.com" : "localhost:3000")
