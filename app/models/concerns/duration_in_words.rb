# frozen_string_literal: true

module DurationInWords
  extend ActiveSupport::Concern

  def duration_in_words(start_attr = :start_date, end_attr = :end_date)
    start_date = send(start_attr)
    end_date   = send(end_attr)
    return nil unless start_date && end_date

    days = (end_date.to_date - start_date.to_date).to_i

    case days
    when 0
      "0 days"
    when 1
      "1 day"
    when 2..6
      "#{days} days"
    when 7..30
      weeks = (days / 7.0).round
      "#{weeks} #{'week'.pluralize(weeks)}"
    when 31..364
      months = (days / 30.0).round
      "#{months} #{'month'.pluralize(months)}"
    else
      years = (days / 365.0).round
      "#{years} #{'year'.pluralize(years)}"
    end
  end
end
