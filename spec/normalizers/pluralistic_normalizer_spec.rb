require "rails_helper"
require "support/shared_examples_a_normalizer"

RSpec.describe PluralisticNormalizer do
  subject(:subject_name) { described_class }

  it_behaves_like "a normalizer" do
    let(:feed) do
      create(
        :feed,
        name: "pluralistic",
        loader: "http",
        processor: "rss",
        normalizer: "pluralistic",
        url: "https://pluralistic.net/feed/",
        import_limit: 2
      )
    end

    before do
      stub_request(:get, %r{pluralistic.net/\d+})
        .to_return(body: file_fixture("feeds/pluralistic/post.html").read)
    end
  end
end
