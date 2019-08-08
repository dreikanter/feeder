module NormalizerTestHelper
  SAMPLE_DATA_PATH = '../data'.freeze

  def subject
    raise NotImplementedError
  end

  def sample_data_path
    File.join(File.expand_path(SAMPLE_DATA_PATH, __dir__), sample_data_file)
  end

  def sample_data_file
    raise NotImplementedError
  end

  def feed
    build(:feed)
  end

  def process_sample_data
    processor.call(File.open(sample_data_path).read, feed).value!
  end

  def processed
    @processed ||= process_sample_data
  end

  def normalize_sample_data
    processed.map { |entity| subject.call(entity[0], entity[1], feed) }
  end

  def normalized
    @normalized ||= normalize_sample_data
  end

  def processor
    raise NotImplementedError
  end

  def subject
    raise NotImplementedError
  end
end
