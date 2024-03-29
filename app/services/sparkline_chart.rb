class SparklineChart
  attr_reader :timeline

  SPARKIES = "▁▂▃▄▅▆▇█".freeze
  ZERO_SPARKY = " ".freeze
  SPARKS_RANGE = SPARKIES.length
  CENTER = SPARKS_RANGE / 2

  # @param :timeline [Hash] {DateTime => Integer}
  def initialize(timeline)
    @timeline = timeline
  end

  def generate
    complemented_timeline.map { |date, value| present(date, value, bucket_for(value)) }
  end

  private

  def present(date, value, bucket)
    {
      date: date,
      value: value,
      bucket: bucket,
      sparky: value.zero? ? ZERO_SPARKY : SPARKIES[bucket]
    }
  end

  def bucket_for(value)
    return 0 if value.zero?
    return CENTER unless ranged_values?
    buckets.find_index { |bucket| bucket.include?(value) }
  end

  def ranged_values?
    min_value.present? && max_value.present? && min_value < max_value
  end

  def buckets
    @buckets ||= SPARKS_RANGE.times.map { |number| (min_value + number * bucket_size)..(min_value + number.succ * bucket_size) }
  end

  def bucket_size
    range / SPARKS_RANGE.to_f
  end

  def range
    max_value - min_value
  end

  def max_value
    timeline.values.max.to_i
  end

  def min_value
    timeline.values.min.to_i
  end

  def complemented_timeline
    dates.index_with { |date| normalized_value(timeline[date]) }
  end

  def normalized_value(value)
    value&.positive? ? value : 0
  end

  def dates
    timeline.empty? ? [] : start_date..end_date
  end

  def start_date
    timeline.keys.min.to_date
  end

  def end_date
    timeline.keys.max.to_date
  end
end
