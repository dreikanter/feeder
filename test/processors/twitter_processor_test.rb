require_relative 'processor_test'

module Processors
  class TwitterProcessorTest < ProcessorTest
    def sample_data_file
      'feed_twitter.json'
    end

    def processor
      Processors::TwitterProcessor
    end

    def data
      @data ||= JSON.parse(sample_data)
    end

    def test_happy_path
      expected = data.map { |entity| entity['id'].to_s }.sort
      result = processor.call(data, limit: 0).map { |uid, _| uid }.sort
      assert_equal(expected, result)
    end
  end
end
