# frozen_string_literal: true

class Taxpayer < ApplicationRecord
  has_many :terminals, dependent: :delete_all
  with_options presence: true do
    validates :tin, :name, :email_address, :phone_number, uniqueness: true
  end
end
