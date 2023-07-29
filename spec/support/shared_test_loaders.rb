RSpec.shared_context "with test loaders" do
  let(:test_loader) do
    Class.new(BaseLoader) do
      def content
        "banana,banana,banana"
      end
    end
  end

  let(:faulty_loader) do
    Class.new(BaseLoader) do
      def content
        raise "loader error"
      end
    end
  end

  before do
    stub_const("TestLoader", test_loader)
    stub_const("FaultyLoader", faulty_loader)
  end
end
