RSpec.describe Importer do
  subject(:service) { described_class }

  let(:feed) do
    create(
      :feed,
      loader: "test",
      processor: "test",
      normalizer: "test",
      import_limit: 2
    )
  end

  let(:test_loader_class) do
    content = file_fixture("sample_rss.xml").read

    Class.new(BaseLoader) do
      define_method :load do
        FeedContent.new(content: content)
      end
    end
  end

  let(:test_processor_class) do
    Class.new(BaseProcessor) do
      define_method :process do |feed_content|
        rss = RSS::Parser.parse(feed_content.content)
        rss.items.map { FeedEntity.new(feed: feed, uid: _1.link, content: _1) }
      end
    end
  end

  let(:test_normalizer_class) do
    Class.new(BaseNormalizer) do
      def uid
        "UID"
      end

      def link
        "https://example.com/sample_post"
      end

      def published_at
        Time.current
      end

      def text
        "Text"
      end

      def attachments
        ["https://example.com/attachment.jpg"]
      end

      def comments
        ["Sample comment"]
      end

      def validation_errors
        []
      end
    end
  end

  context "when on the happy path" do
    it "imports posts" do
      stub_const("TestLoader", test_loader_class)
      stub_const("TestProcessor", test_processor_class)
      stub_const("TestNormalizer", test_normalizer_class)

      importer = service.new(feed)
      expect(importer.import).to be_a(Array)
    end
  end

  context "when missing loader" do
    it "halts with an error" do
      stub_const("TestProcessor", test_processor_class)
      stub_const("TestNormalizer", test_normalizer_class)

      expect { service.new(feed).import }.to raise_error(described_class::ConfigurationError)
        .and(change { feed.reload.errors_count }.by(1))
        .and(change { ErrorReport.where(target: feed).count }.by(1))
    end

    it "reports the error" do
      stub_const("TestLoader", test_loader_class)
      stub_const("TestNormalizer", test_normalizer_class)

      expect { service.new(feed).import }.to raise_error(StandardError)

      expect(feed.error_reports.last).to have_attributes(
        category: "configuration",
        error_class: "FeedConfigurationError",
        context: {
          "feed_service_classes" => {
            "loader_class" => "TestLoader",
            "processor_class" => nil,
            "normalizer_class" => "TestNormalizer"
          }
        }
      )
    end
  end

  context "when missing processor" do
    it "halts with an error" do
      stub_const("TestLoader", test_loader_class)
      stub_const("TestNormalizer", test_normalizer_class)

      expect { service.new(feed).import }.to raise_error(described_class::ConfigurationError)
        .and(change { feed.reload.errors_count }.by(1))
        .and(change { feed.error_reports.count }.by(1))
    end

    it "reports the error" do
      stub_const("TestLoader", test_loader_class)
      stub_const("TestNormalizer", test_normalizer_class)

      expect { service.new(feed).import }.to raise_error(StandardError)

      expect(feed.error_reports.last).to have_attributes(
        category: "configuration",
        error_class: "FeedConfigurationError",
        context: {
          "feed_service_classes" => {
            "loader_class" => "TestLoader",
            "processor_class" => nil,
            "normalizer_class" => "TestNormalizer"
          }
        }
      )
    end
  end

  context "when missing normalizer" do
    it "halts with an error" do
      stub_const("TestLoader", test_loader_class)
      stub_const("TestProcessor", test_processor_class)

      expect { service.new(feed).import }.to raise_error(described_class::ConfigurationError)
        .and(change { feed.reload.errors_count }.by(1))
        .and(change { feed.error_reports.count }.by(1))
    end

    it "reports the error" do
      stub_const("TestLoader", test_loader_class)
      stub_const("TestProcessor", test_processor_class)

      expect { service.new(feed).import }.to raise_error(StandardError)

      expect(feed.error_reports.last).to have_attributes(
        category: "configuration",
        error_class: "FeedConfigurationError",
        context: {
          "feed_service_classes" => {
            "loader_class" => "TestLoader",
            "processor_class" => "TestProcessor",
            "normalizer_class" => nil
          }
        }
      )
    end
  end
end
