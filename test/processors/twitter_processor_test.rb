require 'test_helper'
require_relative '../support/processor_test_helpers'

class TwitterProcessorTest < Minitest::Test
  include ProcessorTestHelpers

  def sample_data_file
    'feed_twitter.json'
  end

  def subject
    TwitterProcessor
  end

  def data
    @data ||= JSON.parse(sample_data)
  end

  def test_happy_path
    expected = data.map { |entity| entity['id'].to_s }.sort
    feed = create(:feed, :twitter)
    result = subject.call(data, feed, import_limit: 0)
    assert(result.success?)
    entities = result.value!.map { |uid, _| uid }.sort
    assert_equal(expected, entities)
  end
end
