require 'rails_helper'

RSpec.describe "PublicPages", type: :request do
  describe "GET /home" do
    it "returns http success" do
      get "/public_pages/home"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /about" do
    it "returns http success" do
      get "/public_pages/about"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /contact" do
    it "returns http success" do
      get "/public_pages/contact"
      expect(response).to have_http_status(:success)
    end
  end

end
