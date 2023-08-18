RSpec.shared_context "with test processors" do
  let(:test_processor) do
    Class.new(BaseProcessor) do
      def process(content)
        [build_post(uid: "1", source_content: content, published_at: Time.current)]
      end
    end
  end

  let(:faulty_processor) do
    Class.new(BaseProcessor) do
      def process(_content)
        raise "processor error"
      end
    end
  end

  before do
    stub_const("TestProcessor", test_processor)
    stub_const("FaultyProcessor", faulty_processor)
  end
end
