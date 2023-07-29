RSpec.shared_context "with test normalizers" do
  let(:test_normalizer) do
    Class.new(BaseNormalizer) do
      def call
        NormalizedEntity.new(
          uid: uid,
          link: "https://example.com/#{uid}",
          published_at: Time.current,
          text: "text",
          attachments: [],
          comments: [],
          validation_errors: []
        )
      end
    end
  end

  let(:validation_errors_normalizers) do
    Class.new(BaseNormalizer) do
      def call
        NormalizedEntity.new(
          uid: uid,
          link: "https://example.com/#{uid}",
          published_at: Time.current,
          text: "text",
          attachments: [],
          comments: [],
          validation_errors: ["test error"]
        )
      end
    end
  end

  let(:faulty_normalizer) do
    Class.new(BaseNormalizer) do
      def call
        raise "normalizer error"
      end
    end
  end

  before do
    stub_const("TestNormalizer", test_normalizer)
    stub_const("ValidationErrorsNormalizer", validation_errors_normalizers)
    stub_const("FaultyNormalizer", faulty_normalizer)
  end
end
