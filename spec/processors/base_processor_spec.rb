require "rails_helper"

RSpec.describe BaseProcessor do
  subject(:processor) { described_class }

  let(:feed) { build(:feed, import_limit: 3) }

  it "responds to #call" do
    expect(processor.respond_to?(:call)).to be_truthy
  end

  it "is abstract" do
    expect { processor.call(content: nil, feed: feed) }.to raise_error(StandardError)
  end

  context "when descendant overrides #entities method" do
    let(:concrete_processor) do
      Class.new(processor) do
        define_method(:entities) { %w[SAMPLE_ENTITY] }
      end
    end

    it "pass #entities result" do
      expect(concrete_processor.call(content: nil, feed: feed)).to eq(%w[SAMPLE_ENTITY])
    end
  end

  context "when entities number exceed the feed limit" do
    let(:concrete_processor) do
      Class.new(processor) do
        define_method(:entities) { %w[1 2 3 4 5] }
      end
    end

    it "returns limited amount of entities" do
      expect(concrete_processor.call(content: nil, feed: feed)).to eq(%w[1 2 3])
    end
  end

  context "when feed limit is not defined" do
    let(:concrete_processor) do
      Class.new(processor) do
        define_method(:entities) { %w[1 2 3 4 5] }
      end
    end

    let(:feed) { build(:feed, import_limit: nil) }

    it "fallbacks to the default limit" do
      expect(concrete_processor.call(content: nil, feed: feed)).to eq(%w[1 2])
    end
  end
end
