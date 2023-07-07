require "rails_helper"

RSpec.describe AerostatNormalizer do
  subject(:normalizer) { described_class }

  let(:feed) { build(:feed, import_limit: 0) }
  let(:content) { file_fixture("feeds/aerostat/feed.xml").read }
  let(:entities) { FeedjiraProcessor.call(content: content, feed: feed) }

  let(:expected) do
    JSON.parse(file_fixture("feeds/aerostat/normalized.json").read).tap do |data|
      data["feed_id"] = feed.id
    end
  end

  it "matches the expected result" do
    result = normalizer.call(entities.first).as_json
    expect(result).to eq(expected)
  end
end
