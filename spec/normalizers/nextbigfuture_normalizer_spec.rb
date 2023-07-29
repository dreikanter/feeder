require "rails_helper"

RSpec.describe NextbigfutureNormalizer do
  subject(:normalizer) { described_class }

  let(:feed) do
    create(
      :feed,
      url: "https://www.nextbigfuture.com/feed",
      loader: "http",
      processor: "feedjira",
      normalizer: "nextbigfuture"
    )
  end

  let(:content) { file_fixture("feeds/nextbigfuture/feed.xml").read }
  let(:entities) { feed.processor_class.new(content: content, feed: feed).entities }
  let(:normalized_entries) { entities.map { normalizer.call(_1) } }

  let(:expected_entity) do
    JSON.parse(file_fixture("feeds/nextbigfuture/entity.json").read).merge("feed_id" => feed.id)
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
