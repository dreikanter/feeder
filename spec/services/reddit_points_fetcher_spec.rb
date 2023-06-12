require "rails_helper"

RSpec.describe RedditPointsFetcher do
  subject(:service) { described_class }

  let(:url) { "https://www.reddit.com/r/worldnews/comments/11yg2e7/germany_shots_fired_at_police_in_reichsbürger/" }
  let(:content) { file_fixture("feeds/reddit/libreddit_comments_page.html").read }
  let(:expected) { 2869 }
  let(:arbitrary_error) { "arbitrary error" }
  let(:thread_url) { %r{^https://.*/r/worldnews/comments/} }

  it "fetches post score" do
    stub_request(:get, thread_url).to_return(body: content)
    expect(service.call(url)).to eq(expected)
  end

  it "raises on HTTP request errors" do
    stub_request(:get, thread_url).to_raise(arbitrary_error)
    expect { service.call(url) }.to raise_error(arbitrary_error)
  end

  it "raises on HTTP response errors" do
    stub_request(:get, thread_url).to_return(status: 404)
    expect { service.call(url) }.to raise_error(described_class::Error)
  end
end
