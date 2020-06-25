require 'test_helper'

class CommitstripTest < Minitest::Test
  def subject
    Pull.call(feed)
  end

  def feed
    build(:feed, **feed_config)
  end

  def feed_config
    {
      name: 'commitstrip',
      processor: 'feedjira',
      normalizer: 'commitstrip',
      url: 'https://www.commitstrip.com/en/feed/'
    }
  end

  def setup
    stub_request(:get, 'https://www.commitstrip.com/en/feed/')
      .to_return(
        body: file_fixture('feeds/commitstrip.xml'),
        headers: { 'Content-Type' => 'text/xml' }
      )
  end

  def test_general_success
    assert(subject.success?)
  end

  def expected_entity
    content = file_fixture('entities/commitstrip.json').read
    result = JSON.parse(content).symbolize_keys
    return result unless result.key?(:published_at)
    result[:published_at] = DateTime.parse(result[:published_at])
    result
  end

  def test_each_entity_is_a_success
    subject.value!.all?(&:success?)
  end

  def test_entity_normalization
    assert_equal(expected_entity, subject.value!.first.value!)
  end
end