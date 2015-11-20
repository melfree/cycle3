class UserMailer < ApplicationMailer
  default from: 'notifications@example.com'
 
  def match_email(user)
    @user = user
    @url  = dashboard_url
    mail(to: @user.email, subject: 'ShoppingBlocks Match Found')
  end
end
