class UserObserver < ActiveRecord::Observer
  def after_create(user)
    Mailer.signup_notification(user).deliver
  end

  def after_save(user)
    Mailer.activation(user).deliver if user.recently_activated?
  end
end
