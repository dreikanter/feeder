require 'rails_helper'

RSpec.describe Feeds do
  subject(:feeds) { described_class.new(path: path).list }

  let(:path) { file_fixture('sample_feeds.yml') }

  let(:configurable_attributes) do
    %w[
      url
      processor
      normalizer
      loader
      after
      refresh_interval
      options
      import_limit
      state
    ].freeze
  end

  let(:expected_feed_names) { %w[oglaf phdcomics xkcd].sort }
  let(:existing_feed) { create(:feed, name: 'xkcd', state: 'disabled') }
  let(:missing_feed) { create(:feed, name: 'missing_from_the_configuration', state: 'enabled') }

  let(:existing_feed_before_update) do
    {
      'after' => nil,
      'import_limit' => nil,
      'loader' => nil,
      'normalizer' => nil,
      'options' => {},
      'processor' => nil,
      'refresh_interval' => 0,
      'state' => 'disabled',
      'url' => 'https://example.com'
    }
  end

  let(:existing_feed_after_update) do
    {
      'after' => Time.parse('2023-06-09 00:00:00.000000000 +0000'),
      'import_limit' => nil,
      'loader' => nil,
      'normalizer' => nil,
      'options' => {},
      'processor' => 'rss',
      'refresh_interval' => 0,
      'state' => 'enabled',
      'url' => 'http://xkcd.com/rss.xml'
    }
  end

  before { Feed.delete_all }

  it 'returns feeds array' do
    expect(feeds.pluck(:name)).to contain_exactly(*expected_feed_names)
    expect(feeds).to all be_a(Feed)
  end

  it 'creates new feeds' do
    expect { feeds }.to change { Feed.enabled.pluck(:name).sort }.from([]).to(expected_feed_names)
  end

  it 'updates existing feeds' do
    expect { feeds }.to change { existing_feed.reload.attributes.slice(*configurable_attributes) }
      .from(existing_feed_before_update).to(existing_feed_after_update)
  end

  it 'updates removed feeds state' do
    expect { feeds }.to change { missing_feed.reload.state }.from('enabled').to('removed')
  end
end
