require "rails_helper"

RSpec.describe PostPublisher do
  subject(:service) { described_class }

  let(:post_with_validation_errors) do
    create(
      :post,
      feed: feed,
      state: "draft",
      validation_errors: ["sample_error"]
    )
  end

  let(:rejected_post) { create(:post, feed: feed, state: "rejected") }
  let(:published_post) { create(:post, feed: feed, state: "published") }
  let(:failed_post) { create(:post, feed: feed, state: "failed") }

  let(:feed) { create(:feed, name: "test") }

  it "should reject post with validation errors" do
    service.new(post_with_validation_errors).publish
    expect(post_with_validation_errors).to be_rejected
  end

  it "skips rejected posts" do
    expect { service.new(rejected_post).publish }.not_to(change { rejected_post.reload })
  end

  it "skips published posts" do
    expect { service.new(published_post).publish }.not_to(change { published_post.reload })
  end

  it "skips failed posts" do
    expect { service.new(failed_post).publish }.not_to(change { failed_post.reload })
  end
end
