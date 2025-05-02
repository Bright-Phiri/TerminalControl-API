# frozen_string_literal: true

class Log < ApplicationRecord
  include CreatedAtFormatting
  belongs_to :user

  scope :search, ->(query) { 
    joins(:user).where("action ILIKE :query OR resource_type ILIKE :query OR description ILIKE :query OR users.user_name ILIKE :query", query: "%#{query}%") if query.present? 
  }
end
