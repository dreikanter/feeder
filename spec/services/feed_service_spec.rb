require "rails_helper"

RSpec.describe FeedService do
  subject(:service) { described_class }

  describe "#initialize" do
    it "requires a feed" do
      expect { service.new(feed: Feed.new) }.not_to raise_error
    end
  end
end
