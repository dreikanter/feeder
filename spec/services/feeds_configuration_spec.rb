require "rails_helper"

RSpec.describe FeedsConfiguration do
  subject(:service) { described_class.new(path: file_fixture("sample_feeds.yml")) }

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
      description
      source
    ].freeze
  end

  let(:expected_feed_names) { %w[oglaf phdcomics xkcd].sort }
  let(:existing_feed) { create(:feed, name: "xkcd", **existing_feed_before_update) }
  let(:missing_feed) { create(:feed, name: "missing_from_the_configuration", state: "enabled") }
  let(:enabled_feed) { create(:feed, name: "phdcomics", state: "enabled") }

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
      "disabling_reason" => "",
      "description" => "",
      "source" => ""
    }
  end

  let(:existing_feed_after_update) do
    {
      "after" => Time.parse("2023-06-09 00:00:00.000000000 +0000"),
      "import_limit" => 10,
      "loader" => "http",
      "processor" => "rss",
      "normalizer" => "xkcd",
      "options" => {"sample_option" => "option_value"},
      "refresh_interval" => 1800,
      "state" => "enabled",
      "url" => "https://xkcd.com/rss.xml",
      "disabling_reason" => "Sample reason",
      "description" => "Feed description",
      "source" => "https://xkcd.com"
    }
  end

  before { Feed.delete_all }

  it "enable expected feeds" do
    service.sync
    expect(enabled_feed_names).to match_array(expected_feed_names)
  end

  it "creates new feeds" do
    expect { service.sync }.to change { enabled_feed_names }.from([]).to(expected_feed_names)
  end

  it "updates existing feeds" do
    expect { service.sync }.to change { existing_feed.reload.attributes.slice(*configurable_attributes) }
      .from(existing_feed_before_update).to(existing_feed_after_update)
  end

  it "knows default path to the production configuration" do
    described_class.sync
    expect(Feed.count).to be_positive
  end

  def enabled_feed_names
    Feed.enabled.pluck(:name).sort
  end
end
