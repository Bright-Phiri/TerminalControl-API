# frozen_string_literal: true

class API::V1::SubscriptionsController < ApplicationController
  def create
  end

  private

  def subscription_params
    params.expect(subscription: [])
  end
end
