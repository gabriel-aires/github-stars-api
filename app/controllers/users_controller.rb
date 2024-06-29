class UsersController < ApplicationController
  def create
    user = User.create!(user_params)
    render json: user, status: :created
  rescue ActiveRecord::RecordInvalid => e
    logger.error "Could not create user with params: #{user_params}"
    render json: { errors: e.record.errors.full_messages }, status: :bad_request
  end

  private

  def user_params = params.permit(:login)
end
