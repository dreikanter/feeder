require "rails_helper"

RSpec.describe Post do
  subject(:model) { described_class }

  let(:post) { create(:post) }
  let(:blank_post) { model.new }

  it "validates" do
    expect(post).to be_valid
  end

  it "requires mandatory attributes presense" do
    expect(blank_post).not_to be_valid
    expect(blank_post.errors.attribute_names).to match_array(%i[feed uid link published_at])
  end

  describe "#state" do
    let(:draft_post) { model.new(state: model::STATE_DRAFT) }
    let(:enqueued_post) { model.new(state: model::STATE_ENQUEUED) }
    let(:rejected_post) { model.new(state: model::STATE_REJECTED) }
    let(:published_post) { model.new(state: model::STATE_PUBLISHED) }
    let(:failed_post) { model.new(state: model::STATE_FAILED) }

    it { expect(draft_post).to be_draft }
    it { expect(enqueued_post).to be_enqueued }
    it { expect(rejected_post).to be_rejected }
    it { expect(published_post).to be_published }
    it { expect(failed_post).to be_failed }

    it { expect(draft_post).to allow_transition_to(:enqueued) }
    it { expect(draft_post).to allow_transition_to(:rejected) }
    it { expect(enqueued_post).to allow_transition_to(:published) }
    it { expect(enqueued_post).to allow_transition_to(:failed) }
  end

  describe "#permalink" do
    let(:expected) { "https://candy.freefeed.net/#{post.feed.name}/#{post.freefeed_post_id}" }

    it { expect(post.permalink).to eq(expected) }
  end
end
