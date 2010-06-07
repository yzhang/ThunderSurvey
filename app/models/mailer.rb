class Mailer < ActionMailer::Base
  layout 'email'
  default :from => "抢答网 <noreply@51qiangda.com>", :content_type => "text/html",
            :charset => "utf-8",:content_transfer_encoding => '8bit'
  
  def registrant_notification(form, row)
    @form = form
    @row = row
    mail(:to => form.user.email,
          :subject => '[抢答网]您的表单有新用户报名')
  end
  
  def forget_password(user,password)
    @user = user 
    @new_password = password
    mail(:to => "#{user.login} <#{user.email}>", :subject => "您在抢座网的新密码")
  end
end
