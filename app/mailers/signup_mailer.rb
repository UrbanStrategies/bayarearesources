class SignupMailer < ActionMailer::Base
  default from: "info@assetbuilding-bayarea.org"

  def invite(user, password)
    @user = user
    @password = password
    mail(to: user.email, cc: 'info@assetbuilding-bayarea.org', subject: "Welcome to the Asset Building Bay Area!")
  end
end
