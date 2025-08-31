# frozen_string_literal: true

module AbilityPermissions
  extend ActiveSupport::Concern

  included do
    def permissions_for(resource_class, user = nil)
      user ||= current_user
      return [] unless user

      ability = Ability.new(user)
      actions = %i[index show create update destroy]
                  .select { |action| ability.can?(action, resource_class) }

      if actions.include?(:index) && actions.include?(:show)
        actions -= %i[index show]
        actions << :read
      end

      actions.map(&:to_s) 
    end
  end
end
