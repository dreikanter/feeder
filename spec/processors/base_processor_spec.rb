require "rails_helper"

RSpec.describe BaseProcessor do
  subject(:processor) { described_class }

  let(:feed) { build(:feed) }

  it { expect { processor.new(content: nil, feed: feed).process }.to raise_error(AbstractMethodError) }
end
