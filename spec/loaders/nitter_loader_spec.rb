require 'rails_helper'

RSpec.describe NitterLoader do
  subject(:loader) { described_class }

  let(:feed) { build(:feed, options: { 'twitter_user' => 'username' }) }
  let(:body) { 'CONTENT BODY' }
  let(:nitter_url) { %r{^https://.*/username/rss$} }

  it "fetches nitter url" do
    stub_request(:get, nitter_url).to_return(body: body)
    result = subject.call(feed)
    assert_equal body, result
  end

  it "passes HTTP client error" do
    stub_request(:get, nitter_url).to_raise(StandardError)
    assert_raises(StandardError) { subject.call(feed) }
  end

  it "require Twitter user option" do
    feed.options = {}
    assert_raises(KeyError) { subject.call(feed) }
  end

end
