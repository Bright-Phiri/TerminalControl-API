# frozen_string_literal: true

module TimestampFormatting
  extend ActiveSupport::Concern

  included do
    def formatted_created_at
      created_at.strftime("%B %d, %Y")
    end

    def formatted_activation_date
      return unless activation_date
      Time.zone.parse(activation_date).strftime("%B %d, %Y")
    end
  end
end

