require 'rails_helper'

RSpec.describe "Terminals", type: :request do
  describe "GET /show" do
    it "returns http success" do
      get "/terminal/show"
      expect(response).to have_http_status(:success)
    end
  end

end
