require "rails_helper"
require "support/shared_test_loaders"
require "support/shared_test_processors"
require "support/shared_test_normalizers"
require "support/shared_with_freefeed_api_request_stubs"

RSpec.describe FeedProcessor do
  subject(:service_call) { described_class.new(feed).process }

  include_context "with test loaders"
  include_context "with test processors"
  include_context "with test normalizers"
  include_context "with freefeed api request stubs"

  before { freeze_time }

  context "when importing new posts" do
    let(:feed) { create(:feed, loader: "test", processor: "test", normalizer: "test", errors_count: 1) }

    before do
      stub_post_create
      stub_attachment_download
      stub_attachment_create
      stub_comment_create
    end

    it { expect { service_call }.to(change { expected_post_imported? }.from(false).to(true)) }
    it { expect { service_call }.to(change(feed, :refreshed_at).from(nil).to(Time.current)) }
    it { expect { service_call }.to(change(feed, :errors_count).from(1).to(0)) }
    it { expect { service_call }.to(change { !!feed.sparkline }.from(false).to(true)) }

    def expected_post_imported?
      Post.exists?(
        feed: feed,
        freefeed_post_id: freefeed_post_id,
        uid: "1",
        link: "https://example.com/1",
        state: "published"
      )
    end
  end

  context "when imported post has validation errors" do
    let(:feed) { create(:feed, loader: "test", processor: "test", normalizer: "validation_errors") }

    it { expect { service_call }.to(change { expected_post_imported? }.from(false).to(true)) }

    def expected_post_imported?
      Post.exists?(
        feed: feed,
        freefeed_post_id: nil,
        uid: "1",
        link: "https://example.com/1",
        state: "rejected"
      )
    end
  end

  context "when loading error" do
    let(:feed) { create(:feed, loader: "faulty", processor: "test", normalizer: "test") }

    it { expect { service_call }.to(change(feed, :errors_count).from(0).to(1)) }
    it { expect { service_call }.to(change(feed, :total_errors_count).from(0).to(1)) }
  end

  context "when processing error" do
    let(:feed) { create(:feed, loader: "test", processor: "faulty", normalizer: "test") }

    it { expect { service_call }.to(change(feed, :errors_count).from(0).to(1)) }
    it { expect { service_call }.to(change(feed, :total_errors_count).from(0).to(1)) }
  end
end
