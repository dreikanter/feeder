require "rails_helper"

RSpec.describe RedditPointsFetcher do
  subject(:result) { described_class.new(url).points }

  let(:url) { "https://www.reddit.com/r/worldnews/comments/11yg2e7/germany_shots_fired_at_police_in_reichsbürger/" }
  let(:content) { file_fixture("feeds/reddit/libreddit_comments_page.html").read }
  let(:expected) { 2869 }
  let(:thread_url) { %r{^https://.*/r/worldnews/comments/} }

  before do
    create(:service_instance, service_type: "libreddit", url: "https://example.com")
  end

  it "fetches post score" do
    stub_request(:get, thread_url).to_return(body: content)
    expect(result).to eq(expected)
  end

  it "raises on HTTP request errors" do
    stub_request(:get, thread_url).to_raise(StandardError)
    expect { result }.to raise_error(StandardError)
  end

  it "raises on HTTP response errors" do
    stub_request(:get, thread_url).to_return(status: 404)
    expect { result }.to raise_error(StandardError)
  end
end
