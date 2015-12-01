class UserMailer < ApplicationMailer
  default from: 'melaniedfreeman@gmail.com'
 
  def match_email(user)
    @user = user
    @url  = dashboard_url
    email = @user.email
    if Rails.env.production?
      email = "mdf@andrew.cmu.edu"
    else
      mail(to: email, subject: 'ShoppingBlocks Match Found')
    end
  end
end
