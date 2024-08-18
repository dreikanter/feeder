require "rails_helper"

RSpec.describe FeedContent do
  subject(:model) { described_class }

  describe "#initialize" do
    it "should accept attributes" do
      instance = model.new(
        raw_content: "RAW_CONTENT",
        imported_at: "IMPORTED_AT",
        import_duration: "IMPORT_DURATION"
      )

      expect(instance.raw_content).to eq("RAW_CONTENT")
      expect(instance.imported_at).to eq("IMPORTED_AT")
      expect(instance.import_duration).to eq("IMPORT_DURATION")
    end
  end
end
