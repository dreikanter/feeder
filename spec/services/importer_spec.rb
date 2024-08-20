require "rails_helper"

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
        content
      end
    end
  end

  context "when on the happy path" do
    it "imports posts" do
      stub_const("TestLoader", test_loader_class)
    end
  end
end
