require "rails_helper"

RSpec.describe PostPublisher do
  subject(:service) { described_class }

  let(:feed) { create(:feed, name: "test", last_post_created_at: nil) }

  before { freeze_time }

  context "with a post that is not ready for publication" do
    let(:draft_post) { create(:post, feed: feed) }
    let(:rejected_post) { create(:post, feed: feed, state: "rejected") }
    let(:published_post) { create(:post, feed: feed, state: "published") }
    let(:failed_post) { create(:post, feed: feed, state: "failed") }

    let(:post_with_validation_errors) do
      create(
        :post,
        feed: feed,
        state: "draft",
        validation_errors: ["sample_error"]
      )
    end

    it "rejects post with validation errors" do
      expect { service.new(post_with_validation_errors).publish }.not_to(change(rejected_post, :reload))
    end

    it "skips draft posts" do
      expect { service.new(rejected_post).publish }.not_to(change(rejected_post, :reload))
    end

    it "skips rejected posts" do
      expect { service.new(rejected_post).publish }.not_to(change(rejected_post, :reload))
    end

    it "skips published posts" do
      expect { service.new(published_post).publish }.not_to(change { published_post.reload })
    end

    it "skips failed posts" do
      expect { service.new(failed_post).publish }.not_to(change { failed_post.reload })
    end
  end

  context "with a post ready for publication" do
    let(:freefeed_post_id) { "f102b70e-0d7a-425a-aca9-68d4462cdea4" }
    let(:attachment_id) { "f102b70e-0d7a-425a-aca9-68d4462cdea5" }
    let(:comment_id) { "f102b70e-0d7a-425a-aca9-68d4462cdea6" }

    let(:post) do
      create(
        :post,
        feed: feed,
        state: "enqueued",
        comments: ["Comment"],
        attachments: ["https://example.com/attachment.jpg"]
      )
    end

    before do
      stub_request(:post, "https://candy.freefeed.net/v1/posts")
        .to_return(
          headers: {"Content-Type" => "application/json"},
          body: {"posts" => {"id" => freefeed_post_id}}.to_json
        )

      stub_request(:get, "https://example.com/attachment.jpg")
        .to_return(
          headers: {"Content-Type" => "image/jpeg"},
          body: file_fixture("1x1.png")
        )

      stub_request(:post, "https://candy.freefeed.net/v1/attachments")
        .to_return(
          headers: {"Content-Type" => "application/json"},
          body: {"attachments" => {"id" => attachment_id}}.to_json
        )

      stub_request(:post, "https://candy.freefeed.net/v1/comments")
        .to_return(
          headers: {"Content-Type" => "application/json"},
          body: {"comments" => {"id" => comment_id}}.to_json
        )

      service.new(post).publish
    end

    it { expect(post.reload.state).to eq("published") }
    it { expect(post.freefeed_post_id).to eq(freefeed_post_id) }
    it { expect(feed.last_post_created_at).to eq(Time.current) }
  end

  context "with a publication error" do
    let(:post) { create(:post, feed: feed, state: "enqueued") }

    before do
      stub_request(:post, "https://candy.freefeed.net/v1/posts")
        .to_return(status: 500)

      service.new(post).publish
    end

    it { expect(post.reload.state).to eq("failed") }
  end
end
