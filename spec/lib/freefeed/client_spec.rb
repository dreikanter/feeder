RSpec.describe Freefeed::Client do
  let(:token) { "TEST_TOKEN" }
  let(:base_url) { "https://example.com" }
  let(:client) { described_class.new(token: token, base_url: base_url) }

  it "initializes with token and base_url" do
    expect(client.token).to eq(token)
    expect(client.base_url).to eq(base_url)
  end
end
