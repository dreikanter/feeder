require "rails_helper"

RSpec.describe Post do
  subject(:model) { described_class }

  let(:post) { create(:post) }
  let(:blank_post) { model.new }

  describe "validations" do
    it { expect(post).to be_valid }

    it "requires mandatory attributes presense" do
      expect(blank_post).not_to be_valid
      expect(blank_post.errors.attribute_names).to match_array(%i[feed uid link published_at])
    end
  end

  describe "state" do
    it { expect(permitted_transitions_from(:draft)).to match_array(%i[enqueued rejected]) }
    it { expect(permitted_transitions_from(:enqueued)).to match_array(%i[failed published]) }
    it { expect(permitted_transitions_from(:published)).to be_empty }
    it { expect(permitted_transitions_from(:failed)).to be_empty }

    def permitted_transitions_from(state)
      model.new(state: state).aasm.states(permitted: true).map(&:name)
    end
  end

  describe "#permalink" do
    let(:expected) { "https://candy.freefeed.net/#{post.feed.name}/#{post.freefeed_post_id}" }

    it { expect(post.permalink).to eq(expected) }
  end

  describe "#ready_for_publication?" do
    it "requires a record to be valid" do
      post.feed = nil
      expect(post).not_to be_ready_for_publication
    end

    it "requires a record to have valid content" do
      post.validation_errors = ["sample error"]
      expect(post).not_to be_ready_for_publication
    end

    it "rejects published records" do
      post.state = "published"
      expect(post).not_to be_ready_for_publication
    end

    it "rejects failed records" do
      post.state = "failed"
      expect(post).not_to be_ready_for_publication
    end

    it "rejects rejected records" do
      post.state = "rejected"
      expect(post).not_to be_ready_for_publication
    end

    it "accepts valid draft records" do
      post.state = "draft"
      expect(post).to be_ready_for_publication
    end

    it "accepts valid enqueued records" do
      post.state = "enqueued"
      expect(post).to be_ready_for_publication
    end
  end
end
