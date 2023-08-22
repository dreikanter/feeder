require "rails_helper"

RSpec.describe CommitstripNormalizer do
  subject(:normalizer) { described_class }

  let(:feed) { build(:feed, import_limit: 0) }
  let(:content) { file_fixture("feeds/commitstrip/feed.xml").read }
  let(:entities) { FeedjiraProcessor.new(content: content, feed: feed).process }
  let(:entity_with_html_entities) { entities[4] }

  let(:expected_entity) do
    JSON.parse(file_fixture("feeds/commitstrip/entity.json").read).tap do |data|
      data["feed_id"] = feed.id
    end
  end

  it "matches the expected result" do
    result = normalizer.call(entities.first).as_json
    expect(result).to eq(expected_entity)
  end

  it "translates HTML entities" do
    # Transforms "&#8211;" to "–"
    result = normalizer.call(entity_with_html_entities)
    expect(result.text).to eq("Apple iPhone X – Juste a small troll - https://www.commitstrip.com/2017/09/13/apple-iphone-x-juste-a-small-troll/")
  end
end
