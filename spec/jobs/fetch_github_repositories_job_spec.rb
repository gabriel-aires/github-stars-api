require 'rails_helper'

RSpec.describe FetchGithubRepositoriesJob, type: :job do
  let(:repositories) do
    [{ "name" => "test1", "stargazers_count" => 0, "private" => false, "fork" => false }]
  end

  let(:client) do
    instance_double(GithubClient, fetch_user_repositories: repositories)
  end

  let(:param) { "test" }

  before do
    allow(GithubClient).to receive(:new).and_return(client)
  end

  describe "#perform" do

    context "with an existing user" do
      before do
        User.create(login: param)
      end

      it "saves repository information" do
        expect(client).to receive(:fetch_user_repositories)
        expect { described_class.new.perform(param) }.to change { Repository.count }.by(1)
      end
    end

    context "with an unknown login" do
      it "raises an exception" do
        expect { described_class.new.perform(param) }.to raise_error(ActiveRecord::RecordNotFound)        
      end
    end

  end
end
