# frozen_string_literal: true

class UserMailer < ApplicationMailer
  def send_default_password(user, default_password)
    @user = user
    @default_password = default_password

    mail to: @user.email_address, subject: "Your Account is Ready – Default Password Inside"
  end
end
