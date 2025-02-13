# frozen_string_literal: true

class Taxpayer < ApplicationRecord
  with_options dependent: :destroy do |assoc|
    assoc.has_many :terminals
    assoc.has_one :subscription
  end

  with_options presence: true do
    validates :tin, :name, :email_address, :phone_number, uniqueness: true
  end

  after_create_commit { LiveDashboardUpdateJob.perform_later }
end
