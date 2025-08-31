# frozen_string_literal: true

class UserRepresenter
  def initialize(user)
    @user = user
  end

  def as_json
    {
      id: user.id,
      email_address: user.email_address,
      user_name: user.user_name,
      first_name: user.first_name,
      last_name: user.last_name,
      phone_number: user.phone_number,
    }
  end

  private

  attr_reader :user
end
