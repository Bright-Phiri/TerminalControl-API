# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.is_admin?
      can :manage, :all
    else
      can :manage, Subscription
      can :manage, Payment
      can :read, Taxpayer
      can :read, Terminal
      cannot :read, User
      cannot :read, Log
    end
  end
end
