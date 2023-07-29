require "rails_helper"
require "support/shared_examples_a_normalizer"

RSpec.describe LivejournalNormalizer do
  subject(:subject_name) { described_class }

  it_behaves_like "a normalizer" do
    let(:feed) do
      create(
        :feed,
        name: "livejournal",
        loader: "http",
        processor: "rss",
        normalizer: "livejournal",
        url: "https://shvarz.livejournal.com/data/rss"
      )
    end
  end
end
