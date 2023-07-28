require "rails_helper"
require "support/shared_examples_a_normalizer"

RSpec.describe GithubBlogNormalizer do
  subject(:subject_name) { described_class }

  it_behaves_like "a normalizer" do
    let(:feed) do
      create(
        :feed,
        name: "github-blog",
        loader: "http",
        processor: "atom",
        normalizer: "github_blog",
        url: "https://github.com/blog/all.atom",
        import_limit: 2
      )
    end

    let(:feed_fixture) { "feeds/github_blog/feed.xml" }
    let(:normalized_fixture) { "feeds/github_blog/normalized.json" }
  end
end
