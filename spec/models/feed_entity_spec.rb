require "rails_helper"

RSpec.describe FeedEntity do
  subject(:model) { described_class }

  let(:instance) { model.new(uid: "UID", content: "CONTENT", feed: "FEED") }

  it { expect(instance.uid).to eq("UID") }
  it { expect(instance.content).to eq("CONTENT") }
  it { expect(instance.feed).to eq("FEED") }
end
