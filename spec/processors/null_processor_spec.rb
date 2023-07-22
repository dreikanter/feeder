require "rails_helper"

RSpec.describe NullProcessor do
  subject(:processor) { described_class }

  let(:entities) { processor.new(content: "arbitrary content", feed: feed).entities }
  let(:feed) { build(:feed) }

  it "returns empty array" do
    expect(entities).to eq([])
  end
end
