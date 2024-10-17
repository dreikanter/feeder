RSpec.describe FeedsConfigurator do
  subject(:service) { described_class }

  before { freeze_time }

  let(:feed_configuration) do
    {
      name: "test_feed",
      state: "enabled",
      url: "https://example.com/rss.xml",
      loader: "test",
      processor: "test",
      normalizer: "test",
      after: "2021-01-01T00:00:00+00:00",
      refresh_interval: 1200,
      import_limit: 2,
      options: {"option" => "option"}
    }
  end

  let(:non_valid_feed_configuration) do
    {
      name: "",
      url: "not-a-url",
      loader: "missing",
      processor: "missing",
      normalizer: "missing",
      after: "not-a-valid-date",
      refresh_interval: "not-an-integer",
      import_limit: "not-an-integer",
      options: "non-hash-value"
    }
  end

  let(:configured_at) { 1.day.ago }

  context "when feed record does not exist" do
    it "creates new records" do
      Feed.delete_all

      feeds_configuration = [
        feed_configuration
      ]

      expect { service.new(feeds_configuration: feeds_configuration).import }.to change(Feed, :count).by(1)

      expected = {
        "name" => "test_feed",
        "posts_count" => 0,
        "refreshed_at" => nil,
        "url" => "https://example.com/rss.xml",
        "processor" => "test",
        "normalizer" => "test",
        "after" => Time.zone.parse("2021-01-01T00:00:00+00:00"),
        "refresh_interval" => 1200,
        "options" => {"option" => "option"},
        "loader" => "test",
        "import_limit" => 2,
        "last_post_created_at" => nil,
        "subscriptions_count" => 0,
        "status" => 0,
        "state" => "enabled",
        "errors_count" => 0,
        "total_errors_count" => 0,
        "state_updated_at" => nil,
        "source_url" => "",
        "description" => "",
        "disabling_reason" => ""
      }

      expect(Feed.find_by(name: "test_feed").attributes).to include(**expected)
    end

    it "skips non-valid configuration" do
      Feed.delete_all

      feeds_configuration = [
        feed_configuration,
        non_valid_feed_configuration
      ]

      expect { service.new(feeds_configuration: feeds_configuration).import }.to change(Feed, :count).by(1)
      expect(Feed.pluck(:name)).to eq([feed_configuration[:name]])
    end
  end

  context "when existing feed was not manually configured" do
    it "updates existing feed" do
      feed = create(
        :feed,
        name: feed_configuration[:name],
        url: "https://example.net/rss.xml",
        loader: "old",
        processor: "old",
        normalizer: "old",
        after: "2020-01-01T00:00:00+00:00",
        refresh_interval: 600,
        import_limit: 1,
        options: {"old" => "options"},
        configured_at: configured_at,
        updated_at: configured_at
      )

      feeds_configuration = [
        feed_configuration
      ]

      service.new(feeds_configuration: feeds_configuration).import

      expect(feed.reload).to have_attributes(
        name: "test_feed",
        url: "https://example.com/rss.xml",
        loader: "test",
        processor: "test",
        normalizer: "test",
        after: DateTime.parse("2021-01-01T00:00:00+00:00"),
        refresh_interval: 1200,
        import_limit: 2,
        options: {"option" => "option"}
      )
    end
  end

  context "when existing feed was manually configured" do
    it "ignores configuration" do
      feed = create(
        :feed,
        name: feed_configuration[:name],
        url: "https://example.net/rss.xml",
        loader: "old",
        processor: "old",
        normalizer: "old",
        after: "2020-01-01T00:00:00+00:00",
        refresh_interval: 600,
        import_limit: 1,
        options: {"old" => "options"},
        configured_at: configured_at,
        updated_at: configured_at + 1.second
      )

      feeds_configuration = [
        feed_configuration
      ]

      expect { service.new(feeds_configuration: feeds_configuration).import }.not_to \
        change { feed.reload.attributes }
    end
  end

  context "when existing feed configuration becomes not valid" do
    it "ignores configuration" do
      feeds_configuration = [
        feed_configuration
      ]

      service.new(feeds_configuration: feeds_configuration).import

      feeds_configuration = [
        feed_configuration.merge(options: "non-hash-value")
      ]

      expect { service.new(feeds_configuration: feeds_configuration).import }.not_to \
        change { Feed.find_by(name: feed_configuration[:name]).attributes }
    end
  end

  context "when feed configuration is removed" do
    it "ignores configuration" do
      feeds_configuration = [
        feed_configuration
      ]

      service.new(feeds_configuration: feeds_configuration).import

      feeds_configuration = []

      expect { service.new(feeds_configuration: feeds_configuration).import }.not_to \
        change { Feed.find_by(name: feed_configuration[:name]).attributes }
    end
  end

  context "when feed state changes" do
    it "updates feed attribute" do
      feeds_configuration = [
        feed_configuration
      ]

      service.new(feeds_configuration: feeds_configuration).import

      feed_configuration[:state] = "disabled"

      expect { service.new(feeds_configuration: feeds_configuration).import }.to \
        change { Feed.find_by(name: feed_configuration[:name]).state }.from("enabled").to("disabled")
    end
  end
end
