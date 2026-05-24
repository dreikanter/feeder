require "rails_helper"

RSpec.describe FeedContent do
  describe ".parseable?" do
    subject(:parseable) { described_class.parseable?(content) }

    context "with valid feed content" do
      let(:content) { file_fixture("feeds/nitter/rss.xml").read }

      it { is_expected.to be(true) }
    end

    context "with an HTML page" do
      let(:content) { "<html><body>Instance has been rate limited</body></html>" }

      it { is_expected.to be(false) }
    end

    context "with empty content" do
      let(:content) { "" }

      it { is_expected.to be(false) }
    end

    context "with nil content" do
      let(:content) { nil }

      it { is_expected.to be(false) }
    end
  end
end
