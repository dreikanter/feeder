require "rails_helper"

RSpec.describe FeedsController do
  render_views

  describe "GET index" do
    it "is okay" do
      # feed = create(:feed)
      get :index
      expect(response).to be_successful
      # expect(response.body).to include(feed.name)
    end
  end
end
