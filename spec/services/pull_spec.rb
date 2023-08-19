require "rails_helper"

class TestProcessor < BaseProcessor
  def entities
    JSON.parse(content).map { build_entity(_1.fetch("link"), _1) }
  end
end

class TestNormalizer < BaseNormalizer
  def link
    content.fetch("link")
  end

  def text
    content.fetch("text")
  end

  def validation_errors
    [].tap do |errors|
      errors << "empty_link" if link.blank?
      errors << "empty_text" if text.blank?
    end
  end
end

RSpec.describe Pull do
  subject(:subject) { described_class }

  let(:feed_url) { "https://example.com/sample_feed" }

  let(:feed) do
    create(
      :feed,
      name: "test",
      loader: "http",
      processor: "test",
      normalizer: "test",
      import_limit: 0,
      url: feed_url
    )
  end

  let(:expected) do
    [
      NormalizedEntity.new(
        feed_id: feed.id,
        uid: "https://example.com/0",
        link: "https://example.com/0",
        published_at: nil,
        text: "Sample entity",
        attachments: [],
        comments: [],
        validation_errors: []
      )
    ]
  end

  let(:feed_entities) do
    [
      NormalizedEntity.new(
        feed_id: feed.id,
        uid: "https://example.com/0",
        link: "https://example.com/0",
        published_at: nil,
        text: "Sample entity",
        attachments: [],
        comments: [],
        validation_errors: []
      ),
      NormalizedEntity.new(
        feed_id: feed.id,
        uid: "https://example.com/1",
        link: "https://example.com/1",
        published_at: nil,
        text: "Sample entity",
        attachments: [],
        comments: [],
        validation_errors: []
      ),
      NormalizedEntity.new(
        feed_id: feed.id,
        uid: "https://example.com/2",
        link: "https://example.com/2",
        published_at: nil,
        text: "",
        attachments: [],
        comments: [],
        validation_errors: ["empty_text"]
      )
    ]
  end

  let(:feed_content) do
    <<~JSON
      [
        {
          "link": "https://example.com/0",
          "text": "Sample entity"
        },
        {
          "link": "https://example.com/1",
          "text": "Sample entity"
        },
        {
          "link": "https://example.com/2",
          "text": null
        }
      ]
    JSON
  end

  let(:processor_error_content) do
    <<~JSON
      [
        {
          "link": "https://example.com/0",
          "text": "Sample entity"
        },
        {
          "text": "Sample entity"
        }
      ]
    JSON
  end

  let(:normalizer_error_content) do
    <<~JSON
      [
        {
          "link": "https://example.com/0",
          "text": "Sample entity"
        },
        {
          "link": "https://example.com/1"
        }
      ]
    JSON
  end

  it "do the call" do
    stub_feed_loader_request(feed_content)
    expect(feed_entities).to eq(subject.call(feed))
  end

  # NOTE: Processor will fail due to the lack of the required 'link' field.
  # Processing error should stop the workflow.
  it "handles processor error" do
    stub_feed_loader_request(processor_error_content)
    assert_raises(KeyError) { subject.call(feed) }
  end

  # NOTE: Normalizer will fail due to the lack of the required 'text' field.
  # Normalizer error should not stop the workflow.
  it "handles normalizer error" do
    stub_feed_loader_request(normalizer_error_content)
    entities = subject.call(feed)
    assert_equal(expected, entities)
  end

  def stub_feed_loader_request(content)
    stub_request(:get, feed_url).to_return(body: content)
  end
end
