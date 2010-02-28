class Mailer < ActionMailer::Base
  default :from => 'admin@juhuiyi'
  
  def signup_notification(user)
    @url  = "http://YOURSITE/activate/#{user.activation_code}"
    
    mail(:to => user.email,
         :subject => '[JUHUIYI]Please activate your new account')
  end
  
  def activation(user)
    @url  = "http://YOURSITE/"
    @user = user
    
    mail(:to => user.email,
         :subject => '[JUHUIYI]Your account has been activated!')
  end
  
  def registrant_notification(form)
    @form = form
    
    mail(:to => form.notify_email,
          :subject => '[JUHUIYI]您提交的活动有新用户报名')
  end
end
