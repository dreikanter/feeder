require "rails_helper"
require "support/shared_examples_a_normalizer"

RSpec.describe RedditNormalizer do
  subject(:subject_name) { described_class }

  before do
    # Clear cache for RedditPointsFetcher
    Rails.cache.clear

    ServiceInstance.delete_all

    create(
      :service_instance,
      service_type: "libreddit",
      url: "https://libreddit.example.com"
    )

    # Stub RedditPointsFetcher requests
    stub_request(:get, %r{^https://libreddit.example.com/})
      .to_return(body: file_fixture("feeds/reddit/libreddit_comments_page.html"))
  end

  it_behaves_like "a normalizer" do
    let(:feed) do
      create(
        :feed,
        name: "reddit",
        url: "https://www.reddit.com/r/worldnews/.rss",
        loader: "http",
        processor: "reddit",
        normalizer: "reddit",
        import_limit: 10
      )
    end
  end

  describe "#text" do
    let(:feed) { build(:feed, name: "reddit", url: "https://www.reddit.com/r/worldnews/.rss", normalizer: "reddit") }
    let(:entity) { FeedEntity.new(uid: thread_url, content: entry_xml, feed: feed) }
    let(:normalized_text) { described_class.call(entity).text }
    let(:title) { "El Niño is now stronger than at any point in the past" }

    let(:thread_url) do
      "https://www.reddit.com/r/worldnews/comments/1w3j6zc/el_niño_is_now_stronger_than_at_any_point_in_the/"
    end

    let(:entry_xml) do
      <<~XML
        <entry>
          <content type="html">#{CGI.escapeHTML(content_html)}</content>
          <link href="#{thread_url}" />
          <published>2023-09-02T06:11:03+00:00</published>
          <title>#{title}</title>
        </entry>
      XML
    end

    context "with a non-ascii source URL" do
      let(:source_url) { "https://example.com/el_niño" }
      let(:content_html) { link_to(thread_url) + link_to(source_url) }

      it "appends the source URL" do
        expect(normalized_text).to eq("#{title}#{BaseNormalizer::SEPARATOR}#{source_url}")
      end
    end

    context "with a malformed source URL" do
      let(:content_html) { link_to(thread_url) + link_to(":") }

      it "skips the malformed URL" do
        expect(normalized_text).to eq(title)
      end
    end

    context "with a relative source URL" do
      let(:content_html) { link_to(thread_url) + link_to("/r/worldnews/") }

      it "skips the relative URL" do
        expect(normalized_text).to eq(title)
      end
    end

    def link_to(url)
      %(<span><a href="#{url}">link</a></span>)
    end
  end
end
