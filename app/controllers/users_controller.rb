class UsersController < ApplicationController
  def create
    user = User.create!(user_params)
    render json: user, status: :created
  rescue ActiveRecord::RecordInvalid => e
    render json: { errors: e.record.errors.full_messages }, status: :bad_request
  end

  private

  def user_params = params.permit(:login)
end
