require "rails_helper"

RSpec.describe FeedConfigurationUpdater do
  subject(:service) { described_class }

  let(:pristine_feed) { create(:feed, name: "xkcd", state: "pristine") }
  let(:enabled_feed) { create(:feed, name: "xkcd", state: "enabled") }
  let(:paused_feed) { create(:feed, name: "xkcd", state: "paused") }
  let(:disabled_feed) { create(:feed, name: "xkcd", state: "disabled") }

  let(:configuration) do
    {
      "after" => Time.parse("2023-06-09 00:00:00.000000000 +0000"),
      "description" => "Feed description",
      "disabling_reason" => "Sample reason",
      "import_limit" => 10,
      "loader" => "http",
      "name" => "xkcd",
      "normalizer" => "xkcd",
      "options" => {"sample_option" => "option_value"},
      "processor" => "rss",
      "refresh_interval" => 1800,
      "source" => "https://xkcd.com",
      "state" => "enabled",
      "url" => "https://xkcd.com/rss.xml"
    }
  end

  let(:feed_before_update) do
    {
      "after" => nil,
      "description" => "",
      "disabling_reason" => "",
      "import_limit" => nil,
      "loader" => nil,
      "normalizer" => nil,
      "options" => {},
      "processor" => nil,
      "refresh_interval" => 0,
      "source" => "",
      "state" => "pristine",
      "url" => "https://example.com"
    }
  end

  let(:feed_after_update) do
    {
      "after" => Time.parse("2023-06-09 00:00:00.000000000 +0000"),
      "description" => "Feed description",
      "disabling_reason" => "Sample reason",
      "import_limit" => 10,
      "loader" => "http",
      "normalizer" => "xkcd",
      "options" => {"sample_option" => "option_value"},
      "processor" => "rss",
      "refresh_interval" => 1800,
      "source" => "https://xkcd.com",
      "state" => "enabled",
      "url" => "https://xkcd.com/rss.xml"
    }
  end

  before { Feed.delete_all }

  it "updates configurable attributes" do
    expect { call_service(pristine_feed.name, true, configuration) }
      .to(change { attrs(pristine_feed) }.from(feed_before_update).to(feed_after_update))
  end

  it "ignores non-configurable attributes" do
    expect { call_service(enabled_feed.name, true, {state: "UNSUPPORTED"}) }
      .not_to(change { enabled_feed.reload.state })
  end

  it "ignores unknown attributes" do
    expect { call_service(enabled_feed.name, true, {banana: "MISSING"}) }
      .not_to(change { enabled_feed.reload.state })
  end

  describe "state control" do
    context "when enabled" do
      it "enables a disabled feed" do
        expect { call_service(disabled_feed.name, true, {}) }
          .to(change { disabled_feed.reload.state }.from("disabled").to("enabled"))
      end

      it "enables a pristine feed" do
        expect { call_service(pristine_feed.name, true, {}) }
          .to(change { pristine_feed.reload.state }.from("pristine").to("enabled"))
      end

      it "keeps paused feed untouched" do
        expect { call_service(paused_feed.name, true, {}) }
          .not_to(change { paused_feed.reload.state })
      end

      it "keeps enabled feed untouched" do
        expect { call_service(enabled_feed.name, true, {}) }
          .not_to(change { enabled_feed.reload.state })
      end
    end

    context "when disabled" do
      it "disables enabled feed" do
        expect { call_service(enabled_feed.name, false, {}) }
          .to(change { enabled_feed.reload.state }.from("enabled").to("disabled"))
      end

      it "disables a pristine feed" do
        expect { call_service(pristine_feed.name, false, {}) }
          .to(change { pristine_feed.reload.state }.from("pristine").to("disabled"))
      end

      it "disables paused feed" do
        expect { call_service(paused_feed.name, false, {}) }
          .to(change { paused_feed.reload.state }.from("paused").to("disabled"))
      end

      it "keeps disabled feed untouched" do
        expect { call_service(disabled_feed.name, false, {}) }
          .not_to(change { disabled_feed.reload.state })
      end
    end
  end

  def attrs(feed)
    feed.reload.attributes.slice("state", *Feed::CONFIGURABLE_ATTRIBUTES.map(&:to_s))
  end

  def call_service(name, enabled, attributes)
    service.new(name: name, enabled: enabled, attributes: attributes).create_or_update
  end
end
