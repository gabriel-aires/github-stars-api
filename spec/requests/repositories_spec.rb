require 'rails_helper'

RSpec.describe "Repositories", type: :request do
  let(:param) { "test" }

  describe "GET /users/:login/repositories" do
    context "with an existing user" do
      before do
        user = User.create(login: param)
        user.repositories.create(name: "test", stars: 0)
      end

      it "lists public repositories" do
        get "/users/#{param}/repositories"
        body = JSON.parse(response.body)

        expect(response).to have_http_status(:ok)
        expect(body.size).to eq(1)
        expect(body.first["name"]).to eq(Repository.last.name)
      end
    end

    context "with an unknown user" do
      it "returns an error" do
        get "/users/#{param}/repositories"
        body = JSON.parse(response.body)

        expect(response).to have_http_status(:not_found)
        expect(body["errors"].first).to eq("User not found")
      end
    end
  end
end
