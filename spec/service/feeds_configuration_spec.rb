require "rails_helper"

RSpec.describe FeedsConfiguration do
  subject(:service) { described_class.new(path: path) }

  let(:path) { file_fixture("sample_feeds.yml") }

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
      disabling_reason
    ].freeze
  end

  let(:expected_feed_names) { %w[oglaf phdcomics xkcd].sort }
  let(:existing_feed) { create(:feed, name: "xkcd", state: "disabled") }
  let(:missing_feed) { create(:feed, name: "missing_from_the_configuration", state: "enabled") }

  let(:existing_feed_before_update) do
    {
      "after" => nil,
      "import_limit" => nil,
      "loader" => nil,
      "normalizer" => nil,
      "options" => {},
      "processor" => nil,
      "refresh_interval" => 0,
      "state" => "disabled",
      "url" => "https://example.com",
      "disabling_reason" => nil
    }
  end

  let(:existing_feed_after_update) do
    {
      "after" => Time.parse("2023-06-09 00:00:00.000000000 +0000"),
      "import_limit" => nil,
      "loader" => nil,
      "normalizer" => nil,
      "options" => {},
      "processor" => "rss",
      "refresh_interval" => 0,
      "state" => "enabled",
      "url" => "http://xkcd.com/rss.xml",
      "disabling_reason" => nil
    }
  end

  before { Feed.delete_all }

  it "returns feeds array" do
    service.sync
    expect(enabled_feed_names).to contain_exactly(*expected_feed_names)
  end

  it "creates new feeds" do
    expect { service.sync }.to change { enabled_feed_names }.from([]).to(expected_feed_names)
  end

  it "updates existing feeds" do
    expect { service.sync }.to change { existing_feed.reload.attributes.slice(*configurable_attributes) }
      .from(existing_feed_before_update).to(existing_feed_after_update)
  end

  it "updates disabled feeds state" do
    expect { service.sync }.to change { missing_feed.reload.state }.from("enabled").to("disabled")
  end

  it "knows default path to the production configuration" do
    described_class.sync
    expect(Feed.count).to be_positive
  end

  def enabled_feed_names
    Feed.enabled.pluck(:name).sort
  end
end
