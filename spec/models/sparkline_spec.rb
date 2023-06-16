require "rails_helper"

RSpec.describe Sparkline do
  subject(:model) { described_class }

  let(:feed) { create(:feed) }

  it "requires feed reference" do
    sparkline = build(:sparkline, feed_id: nil)
    expect(sparkline).not_to be_valid
    expect(sparkline.errors).to have_key(:feed)
  end

  it "require data presence" do
    sparkline = build(:sparkline, feed: feed, data: nil)
    expect(sparkline).not_to be_valid
    expect(sparkline.errors).to have_key(:data)
  end

  it "passes validation" do
    sparkline = build(:sparkline, feed: feed, data: {points: []})
    expect(sparkline).to be_valid
  end
end
