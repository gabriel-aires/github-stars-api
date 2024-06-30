class RepositoriesController < ApplicationController
  def user_repositories
    user = User.includes(:repositories).find_by_login!(params[:login])
    render json: user.repositories, status: :ok
  rescue ActiveRecord::RecordNotFound
    logger.error "Could not find user with login: '#{params[:login]}"
    render json: { errors: ["User not found"] }, status: :not_found
  end
end
