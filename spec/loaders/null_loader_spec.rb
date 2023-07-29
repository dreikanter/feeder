require "rails_helper"

RSpec.describe NullLoader do
  subject(:load_content) { described_class.new(feed).content }

  let(:feed) { build(:feed, loader: "null") }

  it { expect(load_content).to be_nil }
end
