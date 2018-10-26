require 'test_helper'

class NormalizerTest < Minitest::Test
  SAMPLE_DATA_PATH = '../../data'

  def sample_data_path
    File.join(File.expand_path(SAMPLE_DATA_PATH, __FILE__), sample_data_file)
  end

  def sample_data_file
    throw NotImplementedError
  end

  def process_sample_data
    processor.call(open(sample_data_path).read)
  end

  def processed
    @processed ||= process_sample_data
  end

  def normalize_sample_data
    processed.map { |entity| normalizer.process(entity[1]) }
  end

  def normalized
    @normalized ||= normalize_sample_data
  end
end
