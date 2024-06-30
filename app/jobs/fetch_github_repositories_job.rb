class FetchGithubRepositoriesJob < ApplicationJob
  queue_as :default

  retry_on App::ClientError, wait: :polynomially_longer, attempts: 10

  around_perform :handle_connection

  def perform(login)
    logger.info "Saving repository information for user '#{login}'..."
    user = User.find_by_login!(login)
    client = GithubClient.new(login)
    repositories = client.fetch_user_repositories
    ActiveRecord::Base.transaction { save_repositories(user, repositories) }
    logger.info "Successfully saved repository information for user '#{login}'."
  rescue ActiveRecord::RecordNotFound => e
    logger.error "Unknown user: '#{login}'. Unable to create repositories."
    raise
  end

  private

  def handle_connection
    ActiveRecord::Base.connection_pool.with_connection do
      yield
    end
  end

  def save_repositories(user, repositories)
    repositories.each do |repo|
      next if repo["private"] || repo["fork"]
      Repository.create(name: repo["name"], stars: repo["stargazers_count"], user: user)
    end
  end
end
