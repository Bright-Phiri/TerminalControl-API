# frozen_string_literal: true

VALID_PAYMENT_METHODS = ["CASH", "TNM MPAMBA", "AIRTEL MONEY", "VISA"].freeze
VALID_ROLES = ["Officer", "Admin"].freeze
EXPIRY_NOTICE_WINDOW = 10.days
TOKEN_EXPIRY_DURATION = 24.hours
PASSWORD_TOKEN_VALIDITY = 2.hours
SUBSCRIPTION_ACTIONS = {
  "renewed" => {
    subscription: "Renewed",
    payment: "Recorded"
  },
  "created" => {
    subscription: "Created",
    payment: "Created"
  }
}.freeze

