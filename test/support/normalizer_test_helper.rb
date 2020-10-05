module NormalizerTestHelper
  SAMPLE_DATA_PATH = File.expand_path('../data', __dir__).freeze

  def subject
    raise 'not implemented'
  end

  def processor
    raise 'not implemented'
  end

  def sample_data_file
    raise 'not implemented'
  end

  def sample_post_file
    raise 'not implemented'
  end

  protected

  def feed
    build(:feed)
  end

  def processed
    @processed ||= process_sample_data
  end

  def process_sample_data
    processor.call(sample_data, feed)
  end

  def sample_data
    @sample_data ||= sample_file(sample_data_file)
  end

  def sample_post
    @sample_post ||= sample_file(sample_post_file)
  end

  def sample_file(path)
    File.read(File.join(SAMPLE_DATA_PATH, path))
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
