require "rails_helper"
require "support/shared_examples_a_normalizer"

RSpec.describe TheAtlanticPhotosNormalizer do
  subject(:normalizer) { described_class }

  let(:feed) do
    build(
      :feed,
      name: "the-atlantic-photos",
      import_limit: 0,
      processor: "feedjira",
      normalizer: "the_atlantic_photos"
    )
  end

  let(:feed_content) { file_fixture("feeds/#{feed.name}/feed.xml").read }
  let(:feed_entities) { feed.processor_class.new(content: feed_content, feed: feed).process }

  it "resolves normalizer class" do
    expect(feed.normalizer_class).to eq(normalizer)
  end

  it "matches the expected result" do
    json = file_fixture("feeds/#{feed.name}/normalized.json").read
    expected = JSON.parse(json).map { _1.merge("feed_id" => feed.id) }
    result = feed_entities.map { normalizer.call(_1).as_json }

    expect(result).to eq(expected)
  end
end
