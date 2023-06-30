require "rails_helper"

RSpec.describe NextbigfutureNormalizer do
  subject(:normalizer) { described_class }

  let(:feed) { create(:feed, :nextbigfuture) }
  let(:expected_entity) do
    JSON.parse(file_fixture("feeds/nextbigfuture/entity.json").read).tap do |data|
      data["feed_id"] = feed.id
      data["published_at"] = Time.zone.parse(data["published_at"])
    end
  end
  let(:content) { file_fixture("feeds/nextbigfuture/feed.xml").read }
  let(:entities) { feed.processor_class.call(content: content, feed: feed) }
  let(:normalized_entries) { entities.map { |entity| normalizer.call(entity) } }

  let(:expected) do
    JSON.parse(file_fixture("feeds/kotaku/normalized.json").read).map do |data|
      data.merge(
        "feed_id" => feed.id,
        "published_at" => DateTime.parse(data["published_at"])
      )
    end
  end

  before do
    travel_to(DateTime.parse("2023-06-17 01:00:00 +0000"))

    stub_request(:get, %r{^https://www.nextbigfuture.com/.*.html$})
      .to_return(body: file_fixture("feeds/nextbigfuture/post.html").read)
  end

  it "matches the expected result" do
    result = normalizer.call(entities.first).as_json
    expect(result).to eq(expected_entity)
  end
end