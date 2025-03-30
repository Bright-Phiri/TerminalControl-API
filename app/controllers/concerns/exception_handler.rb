# frozen_string_literal: true

module ExceptionHandler
  extend ActiveSupport::Concern

  class NotAuthorized < StandardError; end
  class InventoryLevelError < StandardError; end

  class UnauthorizedAction < StandardError
    def initialize(msg = "Sorry, you are not authorized to perform this action.")
      super
    end
  end

  class InvalidEmail < StandardError
    def initialize(msg = "Email address not found")
      super
    end
  end

  class InvalidCredentials < StandardError
    def initialize(msg = "Invalid username or password")
      super
    end
  end

  class SubscriptionError < StandardError
    def initialize(msg = "Taxpayer already has an active subscription")
      super
    end
  end

  class InvalidUsername < StandardError
    def initialize(msg = "Username not found")
      super
    end
  end

  class InvalidTIN < StandardError
    def initialize(msg = "TIN not found")
      super
    end
  end

  included do
    rescue_from ExceptionHandler::NotAuthorized do |exception|
      render_unauthorized exception.message
    end

    rescue_from ExceptionHandler::UnauthorizedAction do |exception|
      render_forbidden exception.message
    end

    rescue_from ExceptionHandler::InvalidCredentials, ExceptionHandler::SubscriptionError do |exception|
      render_bad_request exception.message, ""
    end

    rescue_from ExceptionHandler::InvalidUsername, ExceptionHandler::InvalidTIN, ExceptionHandler::InvalidEmail do |exception|
      render_not_found exception.message, nil
    end

    rescue_from ActiveRecord::RecordNotFound do
      render_not_found "Record not found", nil
    end

    rescue_from ActiveRecord::RecordNotSaved, ActiveRecord::RecordInvalid, ActiveRecord::RecordNotDestroyed do |exception|
      render_unprocessable_entity "Unprocessable Entity",  exception.record.errors.full_messages
    end
  end
end
