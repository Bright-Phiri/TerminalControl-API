# frozen_string_literal: true

class UserMailer < ApplicationMailer
  def send_default_password(user, default_password)
    @user = user
    @default_password = default_password

    mail to: @user.email_address, subject: "Your Account is Ready – Default Password Inside"
  end

  def send_password_reset
    @user = params[:user]
    mail(to: email_address_with_name(@user.email_address, "#{@user.first_name} #{@user.last_name}"), subject: 'Reset Your Password – Action Required')
  end
end
