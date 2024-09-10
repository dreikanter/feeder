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
    content = sample_rss_content

    Class.new(BaseLoader) do
      define_method :load do
        FeedContent.new(content: content)
      end
    end
  end

  let(:sample_rss_content) { file_fixture("sample_rss.xml").read }

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

  context "when loading error" do
    let(:error_loader_class) do
      Class.new(BaseLoader) do
        def load
          raise LoaderError, "test error"
        end
      end
    end

    before do
      stub_const("TestLoader", error_loader_class)
      stub_const("TestProcessor", test_processor_class)
      stub_const("TestNormalizer", test_normalizer_class)
    end

    it "tracks an error" do
      expect { service.new(feed).import }.to raise_error(LoaderError)
        .and(change { feed.reload.errors_count }.by(1))
        .and(change { feed.error_reports.count }.by(1))
    end

    it "reports an error" do
      expect { service.new(feed).import }.to raise_error(LoaderError)

      expect(feed.error_reports.last).to have_attributes(
        category: "loading",
        error_class: "LoaderError",
        message: "test error"
      )
    end
  end

  context "when processing error" do
    let(:error_processor_class) do
      Class.new(BaseProcessor) do
        def process(*)
          raise ProcessorError, "test error"
        end
      end
    end

    before do
      stub_const("TestLoader", test_loader_class)
      stub_const("TestProcessor", error_processor_class)
      stub_const("TestNormalizer", test_normalizer_class)
    end

    it "tracks an error" do
      expect { service.new(feed).import }.to raise_error(ProcessorError)
        .and(change { feed.reload.errors_count }.by(1))
        .and(change { feed.error_reports.count }.by(1))
    end

    it "reports an error" do
      expect { service.new(feed).import }.to raise_error(ProcessorError)

      expect(feed.error_reports.last).to have_attributes(
        category: "processing",
        error_class: "ProcessorError",
        message: "test error"
      )
    end
  end

  context "when normalization error" do
    let(:error_normalizer_class) do
      Class.new(BaseNormalizer) do
        def normalize(*)
          raise StandardError, "test error"
        end
      end
    end

    let(:amount_of_feed_entities) { RSS::Parser.parse(sample_rss_content).items.count }

    before do
      stub_const("TestLoader", test_loader_class)
      stub_const("TestProcessor", test_processor_class)
      stub_const("TestNormalizer", error_normalizer_class)
    end

    it "report an error for each entity" do
      expect { service.new(feed).import }.to change { feed.reload.errors_count }.by(amount_of_feed_entities)
        .and(change { feed.error_reports.count }.by(amount_of_feed_entities))
    end
  end
end
