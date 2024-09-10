RSpec.describe FeedEntity do
  subject(:model) { described_class }

  describe "#initialize" do
    it "accepts attributes" do
      feed = build(:feed)
      instance = model.new(feed: feed, uid: "UID", content: "CONTENT")

      expect(instance.feed).to eq(feed)
      expect(instance.uid).to eq("UID")
      expect(instance.content).to eq("CONTENT")
    end
  end
end
