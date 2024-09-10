RSpec.describe BaseLoader do
  subject(:service) { described_class }

  let(:feed) { build(:feed) }

  describe "#initialize" do
    it "accepts and exposes a feed" do
      expect(service.new(feed).feed).to eq(feed)
    end
  end

  describe "#load" do
    it "is abstract" do
      expect { service.new(feed).load }.to raise_error(AbstractMethodError)
    end
  end
end
