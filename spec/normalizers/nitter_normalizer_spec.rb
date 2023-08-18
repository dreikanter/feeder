require "rails_helper"
require "support/shared_examples_a_normalizer"

RSpec.describe NitterNormalizer do
  before do
    ServiceInstance.delete_all
    create(:service_instance, service_type: "nitter", state: "enabled", url: "https://nitter.net")

    stub_request(:get, "https://nitter.net/username/rss")
      .to_return(body: file_fixture(feed_fixture).read)
  end

  it_behaves_like "a normalizer" do
    let(:feed) do
      create(
        :feed,
        name: "nitter",
        loader: "nitter",
        processor: "feedjira",
        normalizer: "nitter",
        options: {
          "twitter_user" => "username",
          "only_with_attachments" => true,
          "ignore_retweets" => true
        }
      )
    end
  end
end
