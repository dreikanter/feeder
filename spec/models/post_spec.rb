RSpec.describe Post do
  subject(:model) { described_class }

  describe "validations" do
    it "has a factory with valid defaults" do
      expect(build(:post)).to be_valid
    end

    it "requires feed reference to present" do
      post = build(:post, feed: nil)

      expect(post).not_to be_valid
      expect(post.errors.attribute_names).to include(:feed)
    end

    it "requires uid to present" do
      post = build(:post, uid: nil)

      expect(post).not_to be_valid
      expect(post.errors.attribute_names).to include(:uid)
    end

    it "requires publication timestamp to present" do
      post = build(:post, published_at: nil)

      expect(post).not_to be_valid
      expect(post.errors.attribute_names).to include(:published_at)
    end
  end

  describe "state" do
    it { expect(permitted_transitions_from(:draft)).to match_array(%i[enqueued rejected]) }
    it { expect(permitted_transitions_from(:enqueued)).to match_array(%i[failed published]) }
    it { expect(permitted_transitions_from(:published)).to be_empty }
    it { expect(permitted_transitions_from(:failed)).to be_empty }

    def permitted_transitions_from(state)
      build(:post, state: state).aasm.states(permitted: true).map(&:name)
    end
  end

  describe "#permalink" do
    let(:post) { build(:post, feed: feed) }
    let(:feed) { build(:feed) }
    let(:expected) { "#{Rails.configuration.feeder.freefeed_base_url}/#{post.feed.name}/#{post.freefeed_post_id}" }

    it { expect(post.permalink).to eq(expected) }
  end
end
