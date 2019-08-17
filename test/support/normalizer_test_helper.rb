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

  def sample_post_file
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
    File.open(File.join(SAMPLE_DATA_PATH, sample_data_file)).read
  end

  def fetch_sample_post
    File.open(File.join(SAMPLE_DATA_PATH, sample_post_file)).read
  end

  def normalized
    @normalized ||= normalize_sample_data
  end

  def normalize_sample_data
    processed.map do |entity|
      subject.call(entity[0], entity[1], feed, **options)
    end
  end

  def options
    {}
  end
end
