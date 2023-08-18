require "rails_helper"
require "support/shared_test_loaders"
require "support/shared_test_processors"

RSpec.describe PostsImporter do
  # NOTE: Test processor return a single FeedEntity with uid "1"

  subject(:service_call) { described_class.new(feed).import }

  include_context "with test loaders"
  include_context "with test processors"

  before { freeze_time }

  context "with unsupported feed" do
    context "with missing loader" do
      let(:feed) { create(:feed, loader: "missing") }

      it { expect { service_call }.to raise_error(ClassResolver::Error) }
    end

    context "with missing processor" do
      let(:feed) { create(:feed, loader: "test", processor: "missing") }

      it { expect { service_call }.to raise_error(ClassResolver::Error) }
    end
  end

  context "with loader error" do
    let(:feed) { create(:feed, loader: "faulty", processor: "test") }

    it "updates counters and raises" do
      expect { service_call }.to raise_error("loader error")
        .and(change { feed.reload.errors_count }.by(1))
        .and(change { feed.reload.total_errors_count }.by(1))
        .and(change { feed.reload.refreshed_at }.from(nil).to(Time.current))
    end
  end

  context "with processor error" do
    let(:feed) { create(:feed, loader: "test", processor: "faulty") }

    it "updates counters and raises" do
      expect { service_call }.to raise_error("processor error")
        .and(change { feed.reload.errors_count }.by(1))
        .and(change { feed.reload.total_errors_count }.by(1))
        .and(change { feed.reload.refreshed_at }.from(nil).to(Time.current))
    end
  end

  context "with existing posts" do
    let(:feed) do
      create(
        :feed,
        loader: "test",
        processor: "test",
        errors_count: 1,
        refreshed_at: nil
      )
    end

    before do
      create(:post, feed: feed, uid: "1")
      service_call
      feed.reload
    end

    it "skips posts creation" do
      expect(feed.posts.count).to eq(1)
      expect(feed.reload.errors_count).to be_zero
      expect(feed.reload.refreshed_at).to eq(Time.current)
    end
  end

  context "with new posts" do
    let(:feed) do
      create(
        :feed,
        loader: "test",
        processor: "test",
        errors_count: 1,
        refreshed_at: nil
      )
    end

    before do
      service_call
      feed.reload
    end

    it "creates new posts" do
      expect(Post.where(feed: feed, uid: "1", state: "draft")).to exist
      expect(feed.errors_count).to be_zero
      expect(feed.refreshed_at).to eq(Time.current)
    end
  end
end
