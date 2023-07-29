RSpec.shared_context "with test processors" do
  let(:test_processor) do
    Class.new(BaseProcessor) do
      def entities
        [FeedEntity.new(uid: "1", content: "banana", feed: feed)]
      end
    end
  end

  let(:faulty_processor) do
    Class.new(BaseProcessor) do
      def entities
        raise "processor error"
      end
    end
  end

  before do
    stub_const("TestProcessor", test_processor)
    stub_const("FaultyProcessor", faulty_processor)
  end
end
