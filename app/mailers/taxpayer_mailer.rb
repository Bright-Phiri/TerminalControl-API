# frozen_string_literal: true

class TaxpayerMailer < ApplicationMailer
  def send_default_password(taxpayer, default_password)
    @taxpayer = taxpayer
    @default_password = default_password

    mail to: @taxpayer.email_address, subject: "Your Account is Ready – Default Password Inside"
  end
end
