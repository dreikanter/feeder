require "rails_helper"

RSpec.describe TumblrNormalizer do
  subject(:normalizer) { described_class }

  let(:feed) { create(:feed, :tumblr) }
  let(:content) { file_fixture("feeds/tumblr/feed.xml").read }
  let(:entities) { feed.processor_class.call(content: content, feed: feed) }
  let(:normalized_entries) { entities.map { |entity| normalizer.call(entity) } }

  let(:expected_entity) do
    JSON.parse(file_fixture("feeds/tumblr/entity.json").read).tap do |data|
      data["feed_id"] = feed.id
    end
  end

  before do
    travel_to(DateTime.parse("2023-06-17 01:00:00 +0000"))
  end

  it "matches the expected result" do
    result = normalizer.call(entities.first).as_json
    expect(result).to eq(expected_entity)
  end
end
