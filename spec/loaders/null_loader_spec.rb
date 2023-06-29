require "rails_helper"

RSpec.describe NullLoader do
  subject(:loader) { described_class }

  let(:feed) { build(:feed, loader: "null") }

  it "returns nothing" do
    expect(loader.call(feed)).to be_nil
  end
end
