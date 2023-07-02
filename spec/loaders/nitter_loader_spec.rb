require "rails_helper"

RSpec.describe NitterLoader do
  subject(:loader) { described_class }

  let(:feed) { build(:feed, options: {"twitter_user" => "username"}) }
  let(:body) { "CONTENT BODY" }
  let(:service_instance) { create(:service_instance, service_type: "nitter", state: "enabled", url: "https://example.com") }
  let(:nitter_url) { "https://example.com/username/rss" }

  before do
    ServiceInstance.delete_all
    service_instance
  end

  it "fetches nitter url" do
    stub_request(:get, nitter_url).to_return(body: body)
    result = loader.call(feed)
    expect(body).to eq(result)
  end

  it "require Twitter user option" do
    feed.options = {}
    expect { loader.call(feed) }.to raise_error(KeyError)
  end

  context "on error" do
    it "dumps HTTP client error" do
      expect_failed_loader_to change(Error, :count).by(1)
    end

    it "updates service instance state" do
      expect_failed_loader_to change { service_instance.reload.state }.from("enabled").to("failed")
    end

    it "updates service instance error count" do
      expect_failed_loader_to change { service_instance.reload.errors_count }.by(1)
    end

    it "updates service instance last error timestamp" do
      freeze_time
      expect_failed_loader_to change { service_instance.reload.failed_at }.from(nil).to(Time.current)
    end

    def expect_failed_loader_to(do_things)
      stub_request(:get, nitter_url).to_return(status: 404)
      expect { loader.call(feed) }.to raise_error(StandardError).and(do_things)
    end
  end
end
