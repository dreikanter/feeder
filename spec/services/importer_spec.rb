RSpec.describe Importer do
  subject(:service) { described_class }

  let(:feed) do
    build(
      :feed,
      id: 1,
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
      allow(feed).to receive(:processor_instance)

      importer = service.new(feed)
      expect { importer.import }.to raise_error(FeedConfigurationError)

      expect(feed).not_to have_received(:processor_instance)
    end
  end
end
