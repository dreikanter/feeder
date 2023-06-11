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

  before { DataPoint.for(:reddit).delete_all }

  it 'fetches reddit points' do
    stub_request(:get, thread_url).to_return(body: thread_contents)
    expect(call_processor.map(&:uid)).to eq(expected_uids)
  end

  it 'creates data points to cache post score' do
    stub_request(:get, thread_url).to_return(body: thread_contents)
    expect { call_processor }.to(change { DataPoint.all.pluck(:details) }.from([]).to(expected_data_points))
  end

  it 'ignores posts on score service error' do
    stub_request(:get, thread_url).to_return(status: 404)
    expect(call_processor).to be_empty
    expect(DataPoint.for(:reddit).pluck(:details)).to be_empty
  end

  it 'waits cache expiration before repeating post score requests' do
    import_expected_data_points

    # Will raise WebMock error score request attempt
    expected_data_points
  end

  it 'refreshes cached post scores' do
    freeze_time do
      import_expected_data_points(created_at: 5.hours.ago, custom_details: { "points" => 0 })
      stub_request(:get, thread_url).to_return(body: thread_contents)
      call_processor
      expect(DataPoint.for(:reddit).where(created_at: Time.current).pluck(:details)).to eq(expected_data_points)
    end
  end

  def call_processor
    processor.call(content, feed: feed, import_limit: 0)
  end

  def import_expected_data_points(created_at: nil, custom_details: {})
    expected_data_points.each do |details|
      CreateDataPoint.call(
        :reddit,
        created_at: created_at,
        details: details.merge(custom_details)
      )
    end
  end
end
