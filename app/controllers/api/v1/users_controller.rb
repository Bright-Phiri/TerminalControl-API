# frozen_string_literal: true

class Api::V1::UsersController < ApplicationController
  before_action :set_user, only: %i[show update destroy]
  skip_before_action :authorize_request, only: :register
  wrap_parameters false

  def index
    users = User.all
    render_ok users
  end

  def show
    render_ok @user
  end

  def create
    user = User.new(user_params)
    if user.save
      render_created user, "User successfully created"
    else
      render_unprocessable_entity "Failed to create user", user.errors.full_messages
    end
  end

  def register
    raise ExceptionHandler::UnauthorizedAction if User.exists?

    user = User.new(user_params.merge(role: User::VALID_ROLES[1]))
    if user.save
      render_created user, "Account successfully created"
    else
      render_unprocessable_entity "Failed to register user", user.errors.full_messages
    end
  end

  def update
    if @user.update(user_params)
      render_ok @user
    else
      render_unprocessable_entity "Failed to update user", @user.errors.full_messages
    end
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
