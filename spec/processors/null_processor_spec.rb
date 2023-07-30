require "rails_helper"

RSpec.describe NullProcessor do
  subject(:processor) { described_class }

  let(:result) { processor.new(content: "arbitrary content", feed: feed).process }
  let(:feed) { build(:feed) }

  it { expect(result).to be_empty }
end
