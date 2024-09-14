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
        feed_entity.content.link
      end

      def link
        feed_entity.content.link
      end

      def published_at
        feed_entity.content.pubDate.to_datetime
      end

      def text
        feed_entity.content.title
      end

      def attachments
        [feed_entity.content.enclosure.url]
      end

      def comments
        [feed_entity.content.description]
      end

      def validation_errors
        []
      end
    end
  end

  before { freeze_time }

  context "when on the happy path" do
    it "creates draft post records" do
      stub_const("TestLoader", test_loader_class)
      stub_const("TestProcessor", test_processor_class)
      stub_const("TestNormalizer", test_normalizer_class)

      expect { service.new(feed).import }.to change { feed.posts.draft.count }.by(3)
    end

    it "populates post records" do
      stub_const("TestLoader", test_loader_class)
      stub_const("TestProcessor", test_processor_class)
      stub_const("TestNormalizer", test_normalizer_class)

      service.new(feed).import

      attributes = %w[
        uid
        link
        published_at
        text
        attachments
        comments
        validation_errors
      ]

      expected = [
        {
          "uid" => "https://www.example.com/intergalactic-web-dev",
          "link" => "https://www.example.com/intergalactic-web-dev",
          "published_at" => DateTime.parse("Fri, 16 Aug 2024 09:15:00 UTC"),
          "text" => "The Rise of Intergalactic Web Development",
          "attachments" => ["https://www.example.com/image3.jpg"],
          "comments" => ["Explore emerging trends in faster-than-light data transmission and cross-species user interface design."],
          "validation_errors" => []
        },
        {
          "uid" => "https://www.example.com/alien-code-practices",
          "link" => "https://www.example.com/alien-code-practices",
          "published_at" => DateTime.parse("Sat, 17 Aug 2024 14:30:00 UTC"),
          "text" => "5 Best Practices for Clean Code in Alien Programming Languages",
          "attachments" => ["https://www.example.com/image2.jpg"],
          "comments" => ["Discover essential practices for writing maintainable code in Zorg-9 and other popular extraterrestrial languages."],
          "validation_errors" => []
        },
        {
          "uid" => "https://www.example.com/quantum-ai-mars",
          "link" => "https://www.example.com/quantum-ai-mars",
          "published_at" => DateTime.parse("Sun, 18 Aug 2024 10:00:00 UTC"),
          "text" => "Quantum AI: The Future of Martian Colonization",
          "attachments" => ["https://www.example.com/image1.jpg"],
          "comments" => ["Explore how quantum artificial intelligence is revolutionizing our approach to terraforming Mars."],
          "validation_errors" => []
        }
      ]

      actual = feed.posts.draft.map { _1.slice(attributes) }

      expect(expected).to eq(actual)
    end

    it "is idempotent" do

    end

    it "skips normalization for already processed entities" do

    end

    it "persists non-valid entities as reject posts" do

    end
  end

  context "when missing loader" do
    it "halts with an error" do
      stub_const("TestProcessor", test_processor_class)
      stub_const("TestNormalizer", test_normalizer_class)

      expect { service.new(feed).import }.to raise_error(FeedConfigurationError)
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

      expect { service.new(feed).import }.to raise_error(FeedConfigurationError)
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

      expect { service.new(feed).import }.to raise_error(FeedConfigurationError)
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
