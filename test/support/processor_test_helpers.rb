module ProcessorTestHelpers
  SAMPLE_DATA_PATH = File.expand_path('../data', __dir__).freeze

  def sample_data_path
    File.join(SAMPLE_DATA_PATH, sample_data_file)
  end

  def sample_data_file
    raise NotImplementedError
  end

  def sample_data
    @sample_data ||= File.read(sample_data_path)
  end
end
