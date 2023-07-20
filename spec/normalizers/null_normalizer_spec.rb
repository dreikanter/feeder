require "rails_helper"

RSpec.describe NullNormalizer do
  subject(:normalizer) { described_class }

  let(:feed_entity) { FeedEntity.new(uid: "UID", content: "CONTENT", feed: feed) }
  let(:feed) { build(:feed) }

  it "returns normalized entity" do
    expect(normalizer.call(feed_entity)).to be_a(NormalizedEntity)
  end

  it "returns non-valid normalized entity" do
    expect(normalizer.call(feed_entity).validation_errors).not_to be_empty
  end
end
