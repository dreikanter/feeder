require "rails_helper"

RSpec.describe Post do
  subject(:model) { described_class }

  describe "validations" do
    let(:blank_post) { model.new.tap { _1.validate } }

    it { expect(build(:post)).to be_valid }
    it { expect(build(:post, link: "")).to be_valid }
    it { expect(blank_post.errors.attribute_names).to match_array(%i[feed uid published_at]) }
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
    let(:post) { build(:post, feed: feed) }
    let(:feed) { build(:feed) }
    let(:expected) { "https://candy.freefeed.net/#{post.feed.name}/#{post.freefeed_post_id}" }

    it { expect(post.permalink).to eq(expected) }
  end
end
