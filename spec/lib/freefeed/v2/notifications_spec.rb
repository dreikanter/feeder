# spec/lib/freefeed/v2/notifications_spec.rb
RSpec.describe Freefeed::V2::Notifications do
  let(:client) { Freefeed::Client.new(token: "token", base_url: "https://example.com") }

  describe "#notifications" do
    it "returns notifications list" do
      stub_request(:get, "https://example.com/v2/notifications")
        .with(
          headers: {
            "Authorization" => "Bearer token",
            "User-Agent" => "feeder"
          }
        )
        .to_return(
          status: 200,
          headers: {"Content-Type" => "application/json"},
          body: ""
        )

      response = client.notifications

      expect(response.status.code).to eq(200)
    end
  end
end
