require "rails_helper"
require "support/shared_examples_a_normalizer"

RSpec.describe GithubBlogNormalizer do
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
  end
end
