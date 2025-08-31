# frozen_string_literal: true

class UsersRepresenter
  def initialize(users)
    @users = users
  end

  def as_json
    users.map do |user|
      {
        id: user.id,
        first_name: user.first_name,
        last_name: user.last_name,
        user_name: user.user_name,
        role: user.role,
        email_address: user.email_address,
        phone_number: user.phone_number,
        status: user.status,
      }
    end
  end

  private

  attr_reader :users
end
