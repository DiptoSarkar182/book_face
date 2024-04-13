class UserMailer < ApplicationMailer
  default from: 'diptosarkarhridoy@gmail.com'

  def welcome_email
    @user = params[:user]
    @url  = 'https://book-face.onrender.com/'
    mail(to: @user.email, subject: 'Welcome to Book Face')
  end
end
