require "rails_helper"

RSpec.describe ErrorReport do
  subject(:model) { described_class }

  describe "validation" do
    it "is valid" do
      expect(model.new).to be_valid
    end
  end

  describe "#target" do
    it "has a polymorphic target" do
      feed = create(:feed)
      error_report = model.create(target: feed)

      expect(error_report.reload.target).to eq(feed)
    end
  end
end
