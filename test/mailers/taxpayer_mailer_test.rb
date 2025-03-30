require "test_helper"

class TaxpayerMailerTest < ActionMailer::TestCase
  test "send_default_password" do
    mail = TaxpayerMailer.send_default_password
    assert_equal "Send default password", mail.subject
    assert_equal [ "to@example.org" ], mail.to
    assert_equal [ "from@example.com" ], mail.from
    assert_match "Hi", mail.body.encoded
  end
end
