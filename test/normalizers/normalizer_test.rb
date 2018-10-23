require 'test_helper'

class NormalizerTest < Minitest::Test
  SAMPLE_DATA_PATH = '../../data'

  def sample_data_path
    File.join(File.expand_path(SAMPLE_DATA_PATH, __FILE__), sample_data_file)
  end

  def sample_data_file
    throw NotImplementedError
  end
end
