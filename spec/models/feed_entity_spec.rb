require "rails_helper"

RSpec.describe FeedEntity do
  subject(:model) { described_class }

  let(:instance) { model.new(uid: 123, content: "CONTENT", feed: "FEED") }

  it "stringifies uid" do
    expect(instance.uid).to eq("123")
  end

  it { expect(instance.content).to eq("CONTENT") }
  it { expect(instance.feed).to eq("FEED") }
end
