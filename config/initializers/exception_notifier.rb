Confforge::Application.config.middleware.use ExceptionNotifier, :email_prefix => "[表单异常] ",
   :sender_address => %{"Noreply" <noreply@51qiangzuo.com>},
   :exception_recipients => %w{zhangyuanyi@gmail.com wear63659220@gmail.com} if Rails.env == 'production'