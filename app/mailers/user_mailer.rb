class UserMailer < ApplicationMailer
  def new_registration(user)
    @user = user
    mail(to: User.with_role(:admin).pluck(:email), subject: 'New registration')
  end
end
