class UserMailer < ApplicationMailer
  default from: 'melaniedfreeman@gmail.com'
 
  def match_email(user)
    @user = user
    @url  = dashboard_url
    email = @user.email
    email = "mdf@andrew.cmu.edu" if Rails.env.production?
    mail(to: email, subject: 'ShoppingBlocks Match Found')
  end
end
