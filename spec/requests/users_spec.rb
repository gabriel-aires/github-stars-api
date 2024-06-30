require 'rails_helper'

RSpec.describe "Users", type: :request do
  let(:param) { "test" }

  describe "POST /users/:login" do
    context "with a new login" do
      it "creates a user" do
        initial_user_count = User.count
        post "/users/#{param}"
        final_user_count = User.count
        body = JSON.parse(response.body)

        expect(final_user_count - initial_user_count).to eq(1)
        expect(FetchGithubRepositoriesJob).to have_been_enqueued.with(param)
        expect(response).to have_http_status(:created)
        expect(body["id"]).to eq(User.last.id)
        expect(body["login"]).to eq(param)
      end
    end

    context "with an existing login" do
      before do
        User.create(login: param)
      end

      it "returns an error" do
        post "/users/#{param}"
        body = JSON.parse(response.body)

        expect(response).to have_http_status(:bad_request)
        expect(body["errors"].first).to eq("Login has already been taken")
      end
    end
  end
end
