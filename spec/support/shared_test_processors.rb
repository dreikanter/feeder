RSpec.shared_context "with test processors" do
  let(:test_processor) do
    Class.new(BaseProcessor) do
      def process
        [
          Post.create!(
            uid: "1",
            source_content: "banana",
            published_at: Time.current,
            feed: feed
          )
        ]
      end
    end
  end

  let(:faulty_processor) do
    Class.new(BaseProcessor) do
      def process
        raise "processor error"
      end
    end
  end

  before do
    stub_const("TestProcessor", test_processor)
    stub_const("FaultyProcessor", faulty_processor)
  end
end
