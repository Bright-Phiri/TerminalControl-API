# frozen_string_literal: true

class Api::V1::SubscriptionsController < ApplicationController
  before_action :set_subscription, only: %i[show update destroy]

  def index
    subscriptions = Subscription.paginate(page: params[:page] || 1, per_page: params[:per_page] || 10)
    render_ok ({ subscriptions: SubscriptionsRepresenter.new(subscriptions).as_json, total: subscriptions.total_entries })
  end

  def show
    render_ok SubscriptionRepresenter.new(@subscription).as_json
  end

  def create
    taxpayer = Taxpayer.find(params[:taxpayer_id])
    subscription = taxpayer.create_subscription(subscription_params)
    if subscription.persisted?
       render_created SubscriptionRepresenter.new(subscription).as_json, "Subscription successfully created"
    else
      render_unprocessable_entity "Failed to create subscription", subscription.errors.full_messages
    end
  end

  def update
    if @subscription.update(subscription_params)
      render_ok SubscriptionRepresenter.new(@subscription), "Subscription successfully updated"
    else
      render_unprocessable_entity "Failed to update subscription", @subscription.errors.full_messages
    end
  end

  def destroy
    @subscription.destroy!
    head :no_content
  end

  private

  def set_subscription
    @subscription = Subscription.find(params[:id])
  end

  def subscription_params
    params.expect(subscription: [ :start_date, :end_date ])
  end
end
