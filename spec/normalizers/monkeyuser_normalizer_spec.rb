require "rails_helper"
require "support/shared_examples_a_normalizer"

RSpec.describe MonkeyuserNormalizer do
  subject(:normalizer) { described_class }

  let(:feed) do
    build(
      :feed,
      name: "monkeyuser",
      url: "https://www.monkeyuser.com/feed.xml",
      loader: "http",
      processor: "feedjira",
      normalizer: "monkeyuser",
      import_limit: 2
    )
  end

  let(:feed_content) { file_fixture("feeds/#{feed.name}/feed.xml").read }
  let(:feed_entities) { feed.processor_class.new(content: feed_content, feed: feed).process[0..2] }
  let(:post_content) { file_fixture("feeds/#{feed.name}/post.html").read }

  let(:expected) do
    json = file_fixture("feeds/#{feed.name}/normalized.json").read
    JSON.parse(json).map { _1.merge("feed_id" => feed.id) }
  end

  before do
    stub_request(:get, %r{^https://www.monkeyuser.com/}).to_return(body: post_content)
  end

  it "resolves normalizer class" do
    expect(feed.normalizer_class).to eq(normalizer)
  end

  it "matches the expected result" do
    result = feed_entities.map { normalizer.call(_1).as_json }

    expect(result).to eq(expected)
  end
end
