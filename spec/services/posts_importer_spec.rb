require "rails_helper"
require "support/shared_test_loaders"
require "support/shared_test_processors"
require "support/shared_test_normalizers"

RSpec.describe PostsImporter do
  # NOTE: Test processor return a single FeedEntity with uid "1"

  subject(:service_call) { described_class.new(feed).import }

  include_context "with test loaders"
  include_context "with test processors"
  include_context "with test normalizers"

  context "with unsupported feed" do
    context "with missing loader" do
      let(:feed) { build(:feed, loader: "missing") }

      it { expect { service_call }.to raise_error(ClassResolver::Error) }
    end

    context "with missing processor" do
      let(:feed) { build(:feed, loader: "test", processor: "missing") }

      it { expect { service_call }.to raise_error(ClassResolver::Error) }
    end

    context "with missing normalizer" do
      let(:feed) { build(:feed, loader: "test", processor: "test", normalizer: "missing") }

      it { expect { service_call }.to raise_error(ClassResolver::Error) }
    end
  end

  context "with loader error" do
    let(:feed) { build(:feed, loader: "faulty", processor: "test", normalizer: "test") }

    it { expect { service_call }.to raise_error("loader error") }
  end

  context "with processor error" do
    let(:feed) { build(:feed, loader: "test", processor: "faulty", normalizer: "test") }

    it { expect { service_call }.to raise_error("processor error") }
  end

  context "with normalizer error" do
    let(:feed) { build(:feed, loader: "test", processor: "test", normalizer: "faulty") }

    it { expect { service_call }.not_to(change { feed.posts.count }) }
  end

  context "with existing posts" do
    let(:feed) { build(:feed, loader: "test", processor: "test", normalizer: "faulty") }

    before { create(:post, feed: feed, uid: "1") }

    it "never calls normalizer and skips existing entities" do
      expect { service_call }.not_to(change { feed.posts.count })
    end
  end

  context "with new posts" do
    let(:feed) { build(:feed, loader: "test", processor: "test", normalizer: "test") }

    it { expect { service_call }.to(change { Post.exists?(feed: feed, uid: "1", state: "enqueued") }.from(false).to(true)) }
  end

  context "when all posts has validation errors" do
    let(:feed) { build(:feed, loader: "test", processor: "test", normalizer: "validation_errors") }

    it { expect { service_call }.to(change { Post.exists?(feed: feed, uid: "1", state: "rejected") }.from(false).to(true)) }
  end
end