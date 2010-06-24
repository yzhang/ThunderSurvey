class Mailer < ActionMailer::Base
  layout 'email'
  default :from => "ThunderSurvey <noreply@thundersurvey.com>", :content_type => "text/html",
            :charset => "utf-8",:content_transfer_encoding => '8bit'
  
  def registrant_notification(form, row)
    @form = form
    @row = row
    mail(:to => form.user.email,
          :subject => t(:get_new_answer))
  end
  
  def forget_password(user,password)
    @user = user 
    @new_password = password
    mail(:to => "#{user.login} <#{user.email}>", :subject => t(:password_reset))
  end
end
