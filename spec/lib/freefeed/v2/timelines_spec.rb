RSpec.describe Freefeed::V2::Timelines do
  let(:client) { Freefeed::Client.new(token: "token", base_url: "https://example.com") }

  describe "#best_of" do
    it "gets best of timeline" do
      stub_request(:get, "https://example.com/v2/bestof")
        .with(
          headers: {
            "Authorization" => "Bearer token",
            "User-Agent" => "feeder"
          }
        )
        .to_return(status: 200, body: "{}")

      response = client.best_of

      expect(response.status.code).to eq(200)
    end
  end

  describe "#everything" do
    it "gets everything timeline" do
      stub_request(:get, "https://example.com/v2/everything")
        .with(
          headers: {
            "User-Agent" => "feeder"
          }
        )
        .to_return(status: 200, body: "{}")

      response = client.everything

      expect(response.status.code).to eq(200)
    end
  end

  describe "#own_timeline" do
    context "without filter" do
      it "gets home timeline" do
        stub_request(:get, "https://example.com/v2/timelines/home")
          .with(
            headers: {
              "Authorization" => "Bearer token",
              "User-Agent" => "feeder"
            }
          )
          .to_return(status: 200, body: "{}")

        response = client.own_timeline

        expect(response.status.code).to eq(200)
      end
    end

    context "with filter" do
      it "gets filtered timeline" do
        stub_request(:get, "https://example.com/v2/timelines/filter/photos")
          .with(
            headers: {
              "Authorization" => "Bearer token",
              "User-Agent" => "feeder"
            }
          )
          .to_return(status: 200, body: "{}")

        response = client.own_timeline(filter: "photos")

        expect(response.status.code).to eq(200)
      end
    end

    context "with offset" do
      it "gets timeline with offset" do
        stub_request(:get, "https://example.com/v2/timelines/home")
          .with(
            body: {offset: 10}.to_json,
            headers: {
              "Authorization" => "Bearer token",
              "Content-Type" => "application/json; charset=utf-8",
              "User-Agent" => "feeder"
            }
          )
          .to_return(status: 200, body: "{}")

        response = client.own_timeline(offset: 10)

        expect(response.status.code).to eq(200)
      end
    end
  end

  describe "#timeline" do
    it "gets user timeline" do
      stub_request(:get, "https://example.com/v2/timelines/username")
        .with(
          headers: {
            "Authorization" => "Bearer token",
            "User-Agent" => "feeder"
          }
        )
        .to_return(status: 200, body: "{}")

      response = client.timeline("username")

      expect(response.status.code).to eq(200)
    end

    context "with offset" do
      it "gets timeline with offset" do
        stub_request(:get, "https://example.com/v2/timelines/username")
          .with(
            body: {offset: 10}.to_json,
            headers: {
              "Authorization" => "Bearer token",
              "Content-Type" => "application/json; charset=utf-8",
              "User-Agent" => "feeder"
            }
          )
          .to_return(status: 200, body: "{}")

        response = client.timeline("username", offset: 10)

        expect(response.status.code).to eq(200)
      end
    end
  end

  describe "#comments_timeline" do
    it "gets user comments timeline" do
      stub_request(:get, "https://example.com/v2/timelines/username/comments")
        .with(
          headers: {
            "Authorization" => "Bearer token",
            "User-Agent" => "feeder"
          }
        )
        .to_return(status: 200, body: "{}")

      response = client.comments_timeline("username")

      expect(response.status.code).to eq(200)
    end

    context "with offset" do
      it "gets comments timeline with offset" do
        stub_request(:get, "https://example.com/v2/timelines/username/comments")
          .with(
            body: {offset: 10}.to_json,
            headers: {
              "Authorization" => "Bearer token",
              "Content-Type" => "application/json; charset=utf-8",
              "User-Agent" => "feeder"
            }
          )
          .to_return(status: 200, body: "{}")

        response = client.comments_timeline("username", offset: 10)

        expect(response.status.code).to eq(200)
      end
    end
  end

  describe "#likes_timeline" do
    it "gets user likes timeline" do
      stub_request(:get, "https://example.com/v2/timelines/username/likes")
        .with(
          headers: {
            "Authorization" => "Bearer token",
            "User-Agent" => "feeder"
          }
        )
        .to_return(status: 200, body: "{}")

      response = client.likes_timeline("username")

      expect(response.status.code).to eq(200)
    end

    context "with offset" do
      it "gets likes timeline with offset" do
        stub_request(:get, "https://example.com/v2/timelines/username/likes")
          .with(
            body: {offset: 10}.to_json,
            headers: {
              "Authorization" => "Bearer token",
              "Content-Type" => "application/json; charset=utf-8",
              "User-Agent" => "feeder"
            }
          )
          .to_return(status: 200, body: "{}")

        response = client.likes_timeline("username", offset: 10)

        expect(response.status.code).to eq(200)
      end
    end
  end
end
