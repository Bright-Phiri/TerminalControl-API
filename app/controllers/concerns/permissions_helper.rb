# frozen_string_literal: true

module PermissionsHelper
  extend ActiveSupport::Concern

  included do
    def permissions_for(resource_class, user = nil)
      user ||= current_user
      return [] unless user

      actions = %i[index show create update destroy]
      actions.select { |action| Ability.new(user).can?(action, resource_class) }
    end
  end
end
