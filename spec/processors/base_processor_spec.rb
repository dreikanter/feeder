RSpec.describe BaseProcessor do
  subject(:processor) { described_class.new(feed) }

  let(:feed) { build(:feed) }
  let(:feed_content) { build(:feed_content) }

  describe "#feed" do
    it "returns the feed" do
      expect(processor.feed).to eq(feed)
    end
  end

  describe "#process" do
    it "raises an error" do
      expect { processor.process(feed_content) }.to raise_error(AbstractMethodError)
    end
  end
end
