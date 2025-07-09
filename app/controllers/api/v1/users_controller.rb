# frozen_string_literal: true

class Api::V1::UsersController < ApplicationController
  before_action :set_user, only: %i[show update disable activate destroy]
  skip_before_action :authorize_request, only: :register
  wrap_parameters false

  def index
    users = User.where.not(role: VALID_ROLES.last)
    render_ok users
  end

  def show
    render_ok @user
  end

  def create
    user = User.new(user_params)
    if user.save
      render_created user, "User successfully created. A default password has been sent to the user's email"
    else
      render_unprocessable_entity "Failed to create user", user.errors.full_messages
    end
  end

  def register
    raise ExceptionHandler::UnauthorizedAction if User.exists?

    user = User.new(user_params.merge(role: VALID_ROLES[1]))
    if user.save
      render_created user, "Account successfully created"
    else
      render_unprocessable_entity "Failed to register user", user.errors.full_messages
    end
  end

  def update
    if @user.update(user_params)
      render_ok @user, "User successfully updated"
    else
      render_unprocessable_entity "Failed to update user", @user.errors.full_messages
    end
  end

  def disable
    @user.status = 1
    @user.save(validate: false, touch: false)
    head :ok
  end

  def activate
    @user.status = 0
    @user.save(validate: false, touch: false)
    head :ok
  end

  def destroy
    @user.destroy!
    head :no_content
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.permit(:first_name, :last_name, :user_name, :role, :email_address, :phone_number, :password, :password_confirmation)
  end
end
