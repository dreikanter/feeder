require 'rails_helper'

RSpec.describe RedditProcessor do
  subject(:processor) { described_class }

  let(:content) { file_fixture('feeds/reddit/feed.xml').read }

  let(:feed) do
    build(
      :feed,
      url: 'https://www.reddit.com/r/worldnews/.rss',
      loader: 'http',
      processor: 'reddit',
      normalizer: 'reddit'
    )
  end

  let(:expected_uids) { expected_data_points.map { |details| details["link"] } }

  let(:expected_data_points) { JSON.parse(file_fixture("feeds/reddit/expected_data_points.json").read) }

  before do
    DataPoint.delete_all

    stub_request(:get, %r{^https://.*/r/worldnews/comments/})
      .to_return(body: file_fixture('feeds/reddit/libreddit_comments_page.html').read)
  end

  it 'fetches reddit points' do
    expect(call_processor.map(&:uid)).to eq(expected_uids)
  end

  it 'creates data points' do
    expect { call_processor }.to(change { DataPoint.all.pluck(:details) }.from([]).to(expected_data_points))
  end

  def call_processor
    processor.call(content, feed: feed, import_limit: 0)
  end
end
