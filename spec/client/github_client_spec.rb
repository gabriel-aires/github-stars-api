require 'rails_helper'

RSpec.describe GithubClient do
  let(:param) { "test" }
  subject { described_class.new(param).fetch_user_repositories }  
  let(:repositories) do
    [{ "name" => "test1", "stargazers_count" => 0, "private" => false, "fork" => false }]
  end

  describe "#fetch_user_repositories" do

    context "with a valid user" do
      before do
        stub_request(:get, "https://api.github.com/users/#{param}/repos")
          .to_return(status: 200, body: repositories.to_json, headers: {})
      end

      it "retrieves a list of repositories" do
        expect(subject).to eq(repositories)
      end
    end

    context "with an invalid user" do
      before do
        stub_request(:get, "https://api.github.com/users/#{param}/repos")
          .to_return(status: 404, body: "", headers: {})
      end

      it "raises an exception" do
        expect { subject }.to raise_error(App::ClientError)
      end      
    end
  end
end
