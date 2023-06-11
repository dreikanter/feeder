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
  let(:thread_url) { %r{^https://.*/r/worldnews/comments/} }
  let(:thread_contents) { file_fixture('feeds/reddit/libreddit_comments_page.html').read }

  before { DataPoint.delete_all }

  it 'fetches reddit points' do
    stub_request(:get, thread_url).to_return(body: thread_contents)
    expect(call_processor.map(&:uid)).to eq(expected_uids)
  end

  it 'creates data points' do
    stub_request(:get, thread_url).to_return(body: thread_contents)
    expect { call_processor }.to(change { DataPoint.all.pluck(:details) }.from([]).to(expected_data_points))
  end

  it 'ignores posts on score service error' do
    stub_request(:get, thread_url).to_return(status: 404)
    expect(call_processor).to be_empty
    expect( DataPoint.all.pluck(:details)).to be_empty
  end

  def call_processor
    processor.call(content, feed: feed, import_limit: 0)
  end
end
