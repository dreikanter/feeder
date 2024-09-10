RSpec.describe FeedEntity do
  describe "#initialize" do
    subject(:instance) { build(:feed_entity, feed: feed, uid: "UID", content: "CONTENT") }

    let(:feed) { build(:feed) }

    it "accepts attributes" do
      expect(instance.feed).to eq(feed)
      expect(instance.uid).to eq("UID")
      expect(instance.content).to eq("CONTENT")
    end
  end
end
