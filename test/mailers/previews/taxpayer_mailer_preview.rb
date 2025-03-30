# Preview all emails at http://localhost:3000/rails/mailers/taxpayer_mailer
class TaxpayerMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/taxpayer_mailer/send_default_password
  def send_default_password
    TaxpayerMailer.send_default_password
  end
end
