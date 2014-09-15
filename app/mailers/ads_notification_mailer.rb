class AdsNotificationMailer < ActionMailer::Base
  default from: "otoyabi@gmail.com"

  def ad_result ad, code
    @ad = ad
    @user = ad.user
    @code = code
    mail to: @user.email, subject: "نتیجه بررسی آگهی شما در سایت اتو(مبیل)یابی"

  end

end
