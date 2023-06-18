require "rails_helper"

RSpec.describe HackernewsProcessor do
  subject(:processor) { described_class }

  let(:feed) { create(:feed, loader: "hackernews", processor: "hackernews") }
  let(:content) { HackernewsLoader.call(feed) }

  it "processes content" do
    processor.call(content, feed: feed)
  end
end
