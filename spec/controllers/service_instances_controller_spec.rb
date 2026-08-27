require "rails_helper"

RSpec.describe ServiceInstancesController do
  render_views

  describe "GET index" do
    it "is okay" do
      get :index
      expect(response).to be_successful
    end

    it "renders blank JSON for clients requesting another format" do
      request.headers["Accept"] = "application/json"
      get :index
      expect(response).to be_successful
      expect(response.media_type).to eq("application/json")
      expect(response.body).to eq("{}")
    end
  end
end
