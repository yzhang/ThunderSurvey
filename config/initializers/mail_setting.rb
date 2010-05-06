ActionMailer::Base.smtp_settings = {
  :address              => "51qiangzuo.com",
  :port                 => 25,
  :domain               => "51qiangzuo.com",
  :user_name            => "noreply@51qiangzuo.com",
  :password             => "tellmewhy",
  :authentication       => "login",
  :enable_starttls_auto => true
} 

ActionMailer::Base.default_url_options[:host] = (Rails.env == 'production' ? "www.51qiangzuo.com" : "localhost:3001")
