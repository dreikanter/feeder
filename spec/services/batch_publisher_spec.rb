RSpec.describe BatchPublisher do
  subject(:batch_publisher) do
    described_class.new(
      posts: [first_post, second_post],
      freefeed_client: freefeed_client,
      publisher_class: publisher_class
    )
  end

  let(:freefeed_client) do
    Freefeed::Client.new(
      token: "TEST_TOKEN",
      base_url: "https://freefeed.test"
    )
  end

  let(:publisher_class) { class_double(PostPublisher) }
  let(:publisher_instance) { instance_double(PostPublisher) }

  let(:first_post) { create(:post, state: "enqueued", feed: feed) }
  let(:second_post) { create(:post, state: "enqueued", feed: feed) }
  let(:feed) { create(:feed) }

  describe "#publish" do
    before do
      allow(publisher_class).to receive(:new)
        .with(post: anything, freefeed_client: freefeed_client)
        .and_return(publisher_instance)

      allow(publisher_instance).to receive(:publish)
    end

    context "when posts are enqueued" do
      it "attempts to publish all enqueued posts" do
        allow(publisher_class).to receive(:new)
          .with(post: first_post, freefeed_client: freefeed_client)
          .and_return(publisher_instance)

        allow(publisher_class).to receive(:new)
          .with(post: second_post, freefeed_client: freefeed_client)
          .and_return(publisher_instance)

        expect(publisher_instance).to receive(:publish).twice

        batch_publisher.publish
      end
    end

    context "when some posts are not enqueued" do
      let(:second_post) { create(:post, state: "draft", feed: feed) }

      it "only publishes enqueued posts" do
        expect(publisher_class).to receive(:new)
          .with(post: first_post, freefeed_client: freefeed_client)
          .once
          .and_return(publisher_instance)

        expect(publisher_instance).to receive(:publish).once

        expect(publisher_class).not_to receive(:new)
          .with(post: second_post, freefeed_client: freefeed_client)

        batch_publisher.publish
      end
    end

    context "when post state changes during processing" do
      it "skips posts that are no longer enqueued" do
        allow(first_post).to receive(:reload).and_return(
          create(:post, state: "published", feed: feed)
        )

        expect(publisher_class).not_to receive(:new)
          .with(post: first_post, freefeed_client: freefeed_client)

        expect(publisher_class).to receive(:new)
          .with(post: second_post, freefeed_client: freefeed_client)
          .once
          .and_return(publisher_instance)

        expect(publisher_instance).to receive(:publish).once

        batch_publisher.publish
      end
    end
  end
end
