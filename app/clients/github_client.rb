class GithubClient
  include HTTParty
  base_uri 'https://api.github.com'

  def initialize(login)
    @login = login
  end

  def fetch_user_repositories
    logger.info "Fetching user repositories for '#{@login}'..."
    response = self.class.get("/users/#{@login}/repos")
    return JSON.parse(response.body) if response.code == 200

    raise App::ClientError
  rescue StandardError => e
    logger.error "Error while fetching user repositories for '#{@login}'"
    logger.error e.backtrace.join("\n")

    raise App::ClientError
  end

  private

  def logger = Rails.logger
end
