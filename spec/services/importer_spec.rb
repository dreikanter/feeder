require "rails_helper"

RSpec.describe Importer do
  subject(:service) { described_class }

  let(:feed) do
    create(
      :feed,
      loader: "http",
      processor: "rss",
      normalizer: "rss",
      import_limit: 2
    )
  end

  it "imports posts" do
    stub_request(:get, feed.url).to_return(body: file_fixture("sample_rss.xml"))
    importer = service.new(feed: feed)

    expect { importer.import }.to change(Post, :count).by(2)
  end
end
