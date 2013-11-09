class UserMailer < ActionMailer::Base
  
  default from: "CalTeach <lauraimai@calteach.com>"
  
  def account_created_email(user, password)
    @user = user
    @password = password
    mail(
      to: "#{user.name} <#{user.email}>",
      subject: "CalTeach account created"
    )
  end
end
