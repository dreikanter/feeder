require 'rails_helper'

RSpec.describe RedditPointsFetcher do
  subject { described_class }

  let(:url) { 'https://www.reddit.com/r/worldnews/comments/11yg2e7/germany_shots_fired_at_police_in_reichsbürger/' }
  let(:content) { file_fixture('feeds/reddit/libreddit_comments_page.html').read }
  let(:expected) { 2869 }

  it 'fetches post score' do
    stub_request(:get, %r{^https://.*/r/worldnews/comments/}).to_return(body: content)
    expect(subject.call(url)).to eq(expected)
  end

  it 'fetches post score' do
    stub_request(:get, %r{^https://.*/r/worldnews/comments/}).to_return(body: content)
    expect(subject.call(url)).to eq(expected)
  end
end
