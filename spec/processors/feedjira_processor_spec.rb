require "rails_helper"

RSpec.describe FeedjiraProcessor do
  subject(:processor) { described_class }

  let(:content) { file_fixture("processors/feedjira/rss.xml").read }
  let(:feed) { create(:feed) }
  let(:expected) { JSON.parse(file_fixture("processors/feedjira/result.json").read) }

  before do
    travel_to(DateTime.parse("2023-07-30T00:00:00.000Z"))
    processor.new(feed: feed, content: content).process
  end

  it "matches expected data" do
    expected.each do |expected_data|
      expect(feed.posts.find_by(**expected_data)).to be_present
    end
  end
end
