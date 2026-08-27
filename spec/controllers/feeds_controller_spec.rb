require "rails_helper"

RSpec.describe FeedsController do
  render_views

  describe "GET index" do
    it "is okay" do
      feed = create(:feed)
      get :index
      expect(response).to be_successful
      expect(response.body).to include(feed.name)
    end

    it "renders HTML for clients requesting another format" do
      feed = create(:feed)
      request.headers["Accept"] = "application/json"
      get :index
      expect(response).to be_successful
      expect(response.media_type).to eq("text/html")
      expect(response.body).to include(feed.name)
    end

    it "renders HTML for an explicit format extension" do
      get :index, format: :json
      expect(response).to be_successful
      expect(response.media_type).to eq("text/html")
    end
  end
end
