require "rails_helper"

RSpec.describe NullProcessor do
  subject(:processor) { described_class }

  let(:feed) { build(:feed) }

  it "returns empty array" do
    expect(processor.call(content: nil, feed: feed)).to eq([])
  end
end
