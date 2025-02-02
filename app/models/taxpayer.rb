# frozen_string_literal: true

class Taxpayer < ApplicationRecord
  with_options dependent: :delete_all do |assoc|
    assoc.has_many :terminals
    assoc.has_many :payments
  end

  with_options presence: true do
    validates :tin, :name, :email_address, :phone_number, uniqueness: true
  end
end
