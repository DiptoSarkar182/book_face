class UserMailer < ApplicationMailer
  default from: 'diptomanchester2018@gmail.com'

  def welcome_email
    @user = params[:user]
    @url  = 'https://book-face.onrender.com/'
    mail(to: @user.email, subject: 'Welcome to Members only')
  end
end
