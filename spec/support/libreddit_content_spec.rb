require "rails_helper"

RSpec.describe LibredditContent do
  let(:post_page) { file_fixture("feeds/reddit/libreddit_comments_page.html").read }
  let(:challenge_page) { file_fixture("feeds/reddit/libreddit_challenge_page.html").read }

  describe ".post_score" do
    subject(:post_score) { described_class.post_score(content) }

    context "with a post page" do
      let(:content) { post_page }

      it { is_expected.to eq("2869") }
    end

    context "with an anti-bot challenge page" do
      let(:content) { challenge_page }

      it { is_expected.to be_nil }
    end

    context "with a score element missing the title attribute" do
      let(:content) { '<div class="post_score">2.9k</div>' }

      it { is_expected.to be_nil }
    end

    context "with empty content" do
      let(:content) { "" }

      it { is_expected.to be_nil }
    end

    context "with nil content" do
      let(:content) { nil }

      it { is_expected.to be_nil }
    end
  end

  describe ".post_score?" do
    subject(:post_score?) { described_class.post_score?(content) }

    context "with a post page" do
      let(:content) { post_page }

      it { is_expected.to be(true) }
    end

    context "with an anti-bot challenge page" do
      let(:content) { challenge_page }

      it { is_expected.to be(false) }
    end

    context "with nil content" do
      let(:content) { nil }

      it { is_expected.to be(false) }
    end
  end
end
