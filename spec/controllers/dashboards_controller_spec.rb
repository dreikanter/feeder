require 'rails_helper'

RSpec.describe DashboardsController do
  render_views

  describe 'GET show' do
    it 'is okay' do
      feed = create(:feed)
      get :show
      expect(response).to be_successful
      expect(response.body).to include(feed.name)
    end
  end
end
