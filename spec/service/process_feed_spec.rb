require 'rails_helper'

RSpec.describe ProcessFeed do
  subject(:service) { described_class }

  let(:feed_with_faulty_loader) do
    create(
      :feed,
      loader: 'faulty',
      processor: 'null',
      normalizer: 'null'
    )
  end

  let(:feed_with_faulty_processor) do
    create(
      :feed,
      loader: 'null',
      processor: 'faulty',
      normalizer: 'null'
    )
  end

  let(:feed_with_faulty_normalizer) do
    create(
      :feed,
      loader: 'null',
      processor: 'test',
      normalizer: 'faulty'
    )
  end

  class FaultyLoader < BaseLoader
    def perform
      raise 'test error'
    end
  end

  class FaultyProcessor < BaseProcessor
    def entities
      raise 'test error'
    end
  end

  class TestProcessor < BaseProcessor
    def entities
      [
        Entity.new(uid: '1', content: '', feed: Feed.new),
        Entity.new(uid: '2', content: '', feed: Feed.new)
      ]
    end
  end

  class FaultyNormalizer < BaseNormalizer
    def call
      raise
    end
  end

  it 'should increment error counters when loader fails' do
    expect { service.call(feed_with_faulty_loader) }.to increment_error_counters(feed_with_faulty_loader)
  end

  it 'should dump feed error when loader fails' do
    expect { service.call(feed_with_faulty_processor) }.to change { errors_count(feed_with_faulty_processor) }.by(1)
  end

  it 'should increment error counters when processor fails' do
    expect { service.call(feed_with_faulty_processor) }.to increment_error_counters(feed_with_faulty_processor)
  end

  it 'should dump feed error when processor fails' do
    expect { service.call(feed_with_faulty_processor) }.to change { errors_count(feed_with_faulty_processor) }.by(1)
  end

  it 'should dump normalization errors' do
    expect { service.call(feed_with_faulty_normalizer) }.to change { errors_count(feed_with_faulty_normalizer) }.by(2)
  end

  it 'should not create posts on normalization error' do
    expect { service.call(feed_with_faulty_normalizer) }.not_to change { Post.count }
  end

  def increment_error_counters(feed)
    change { feed.reload.attributes.slice('errors_count', 'total_errors_count') }
      .from({ 'errors_count' => 0, 'total_errors_count' => 0 })
      .to({ 'errors_count' => 1, 'total_errors_count' => 1 })
  end

  def errors_count(target)
    Error.where(target: target).count
  end
end
