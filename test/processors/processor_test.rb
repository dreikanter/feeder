require 'test_helper'

module Processors
  class ProcessorTest < Minitest::Test
    SAMPLE_DATA_PATH = '../data'.freeze

    def sample_data_path
      File.join(File.expand_path(SAMPLE_DATA_PATH, __dir__), sample_data_file)
    end

    def sample_data_file
      raise NotImplementedError
    end

    def sample_data
      @sample_data ||= File.read(sample_data_path)
    end
  end
end
