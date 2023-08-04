require "rails_helper"

RSpec.describe ServiceInstancesController do
  render_views

  describe "GET index" do
    it "is okay" do
      get :index
      expect(response).to be_successful
    end
  end
end
