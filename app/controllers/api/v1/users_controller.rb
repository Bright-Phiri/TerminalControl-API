# frozen_string_literal: true

class API::V1::UsersController < ApplicationController
  before_action :set_user, only: %i[show update destroy]

  def index
    users = User.all
    render json: users
  end

  def show
    render json @user
  end

  def create
    user = User.new(user_params)
    if user.save
      render json: user, status: :created
    else
      render json: user.errors.full_messages, status: :unprocessable_entity
    end
  end

  def register
    raise ExceptionHandler::UnauthorizedAction if User.exists?

    user = User.new(user_params.merge(role: User::VALID_ROLES[1]))
    if user.save
      render json: user, status: :created
    else
      render json: user.errors.full_messages, status: :unprocessable_entity
    end
  end

  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors.full_messages, status: :unprocessable_entity
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
    params.expect(user: [ :first_name, :last_name, :user_name, :role, :email_address, :phone_number, :password, :password_confirmation ])
  end
end
