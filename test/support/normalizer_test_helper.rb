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
    processor.call(sample_data, feed).value!
  end

  def sample_data
    @sample_data ||=
      File.read(File.join(SAMPLE_DATA_PATH, sample_data_file))
  end

  def sample_post
    @sample_post ||=
      File.read(File.join(SAMPLE_DATA_PATH, sample_post_file))
  end

  def normalized
    @normalized ||= normalize_sample_data
  end

  def normalize_sample_data
    processed.map do |entity|
      subject.call(entity.uid, entity.content, feed, **options)
    end
  end

  def options
    {}
  end
end
