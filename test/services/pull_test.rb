# frozen_string_literal: true

require 'test_helper'
require_relative '../support/test_processor'
require_relative '../support/test_normalizer'

class PullTest < Minitest::Test
  def subject
    Pull
  end

  def setup
    Feed.destroy_all
  end

  FEED_URL = 'https://example.com/sample_feed'

  def feed
    create(
      :feed,
      name: :test,
      loader: :http,
      import_limit: 0,
      url: FEED_URL
    )
  end

  def stub_feed_loader_request(fixture_path)
    stub_request(:get, FEED_URL).to_return(body: file_fixture(fixture_path))
  end

  TEST_FEED_ENTITIES = [
    {
      uid: 'https://example.com/0',
      link: 'https://example.com/0',
      published_at: nil,
      text: 'Sample entity',
      attachments: [],
      comments: [],
      validation_errors: []
    },
    {
      uid: 'https://example.com/1',
      link: 'https://example.com/1',
      published_at: nil,
      text: 'Sample entity',
      attachments: [],
      comments: [],
      validation_errors: []
    },
    {
      uid: 'https://example.com/2',
      link: 'https://example.com/2',
      published_at: nil,
      text: '',
      attachments: [],
      comments: [],
      validation_errors: ['empty_text']
    }
  ].freeze

  def test_call
    stub_feed_loader_request('feeds/test_feed.json')
    entities = subject.call(feed)
    assert_equal(TEST_FEED_ENTITIES, entities)
  end

  # NOTE: Processor will fail due to the lack of the required 'link' field.
  # Processing error should stop the workflow.
  def test_processor_error
    stub_feed_loader_request('feeds/test_processor_error.json')
    assert_raises(KeyError) { subject.call(feed) }
  end

  NORMALIZER_TEST_ENTITIES = [
    {
      uid: 'https://example.com/0',
      link: 'https://example.com/0',
      published_at: nil,
      text: 'Sample entity',
      attachments: [],
      comments: [],
      validation_errors: []
    }
  ].freeze

  # NOTE: Normalizer will fail due to the lack of the required 'text' field.
  # Normalizer error should not stop the workflow.
  def test_normalizer_error
    stub_feed_loader_request('feeds/test_normalizer_error.json')
    entities = subject.call(feed)
    assert_equal(NORMALIZER_TEST_ENTITIES, entities)
  end
end
