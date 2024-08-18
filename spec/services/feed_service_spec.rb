require "rails_helper"

RSpec.describe FeedService do
  subject(:service) { described_class }

  describe "#initialize" do
    it "requires a feed" do
      service.new(feed: Feed.new)
    end
  end
end
