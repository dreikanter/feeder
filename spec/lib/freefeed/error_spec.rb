RSpec.describe Freefeed::Error do
  it "returns the correct error class for a response code" do
    response = HTTP::Response.new(status: 404, version: "1.1", body: "", request: nil)

    expect(described_class.for(response)).to eq(Freefeed::Error::NotFound)
  end
end
