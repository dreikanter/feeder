RSpec.shared_examples "a normalizer" do
  subject(:normalizer) { described_class }

  let(:feed) { raise "undefined" }
  let(:feed_fixture) { "feeds/#{feed.name}/feed.xml" }
  let(:normalized_fixture) { "feeds/#{feed.name}/normalized.json" }
  let(:normalized_entries) { Pull.call(feed) }

  let(:expected_normalized_entries) do
    JSON.parse(file_fixture(normalized_fixture).read).map do |data|
      data.merge("feed_id" => feed.id)
    end
  end

  before do
    Feed.delete_all
    travel_to(DateTime.parse("2023-06-17 01:00:00 +0000"))
    stub_request(:get, feed.url).to_return(body: file_fixture(feed_fixture).read)
  end

  it { expect(feed.normalizer_class).to eq(described_class) }
  it { expect(normalized_entries.as_json).to eq(expected_normalized_entries) }
end
