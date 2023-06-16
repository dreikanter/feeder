require "rails_helper"

RSpec.describe Sparkline do
  subject(:model) { described_class }

  it "requires feed reference" do
    sparkline = build(:sparkline, feed_id: nil)
    sparkline.validate
    expect(sparkline).not_to be_valid
    expect(sparkline.errors).to have_key(:feed)
  end
end
