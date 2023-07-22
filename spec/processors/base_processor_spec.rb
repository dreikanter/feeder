require "rails_helper"

RSpec.describe BaseProcessor do
  subject(:processor) { described_class }

  let(:feed) { build(:feed) }

  let(:concrete_processor) do
    Class.new(processor) do
      define_method(:entities) { %w[SAMPLE_ENTITY] }
    end
  end

  it { expect { processor.new(content: nil, feed: feed).entities }.to raise_error(StandardError) }
  it { expect(concrete_processor.new(content: nil, feed: feed).entities).to eq(%w[SAMPLE_ENTITY]) }
end
