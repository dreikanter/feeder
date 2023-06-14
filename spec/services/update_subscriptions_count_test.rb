require "rails_helper"

RSpec.describe UpdateSubscriptionsCount do
  subject(:service) { described_class }

  let(:feed) { create(:feed, subscriptions_count: 0) }
  let(:expected_subscribers_count) { 2 }

  before do
    Feed.delete_all

    stub_request(:get, "https://candy.freefeed.net/v2/timelines/#{feed.name}")
      .to_return(
        body: {timelines: {subscribers: expected_subscribers_count.times.map(&:to_s)}}.to_json,
        headers: {"Content-Type" => "application/json"}
      )
  end

  it "updates subscriptions count" do
    service.call(feed.name)
    expect(feed.reload.subscriptions_count).to eq(expected_subscribers_count)
  end
end
