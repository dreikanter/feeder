require "rails_helper"

RSpec.describe Entity do
  subject(:model) { described_class }

  it "initializes attributes" do
    entity = Entity.new(uid: "UID", content: "CONTENT", feed: "FEED")
    expect(entity.uid).to eq("UID")
    expect(entity.content).to eq("CONTENT")
    expect(entity.feed).to eq("FEED")
  end
end
