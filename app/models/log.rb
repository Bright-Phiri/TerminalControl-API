# frozen_string_literal: true

class Log < ApplicationRecord
  include PgSearch::Model
  include TimestampFormatting

  belongs_to :user

  pg_search_scope :search,
    against: [:action, :resource_type, :description],
    associated_against: {
      user: :user_name
    },
    using: {
      tsearch: { prefix: true }
    }
end
