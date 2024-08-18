require "rails_helper"

RSpec.describe FeedEntity do
  subject(:model) { described_class }

  describe "#initialize" do
    it "should accept attributes" do
      instance = model.new(uid: "UID", content: "CONTENT")

      expect(instance.uid).to eq("UID")
      expect(instance.content).to eq("CONTENT")
    end
  end
end
