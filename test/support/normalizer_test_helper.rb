module NormalizerTestHelper
  SAMPLE_DATA_PATH = File.expand_path('../data', __dir__).freeze

  def subject
    raise NotImplementedError
  end

  def processor
    raise NotImplementedError
  end

  def sample_data_file
    raise NotImplementedError
  end

  protected

  def feed
    build(:feed)
  end

  def processed
    @processed ||= process_sample_data
  end

  def process_sample_data
    processor.call(fetch_sample_data, feed).value!
  end

  def fetch_sample_data
    File.open(sample_data_path).read
  end

  def sample_data_path
    File.join(SAMPLE_DATA_PATH, sample_data_file)
  end

  def normalized
    @normalized ||= normalize_sample_data
  end

  def normalize_sample_data
    processed.map { |entity| subject.call(entity[0], entity[1], feed) }
  end
end
