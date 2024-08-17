class BaseNormalizer
  attr_reader :feed, :entity

  def initialize(feed:, entity:)
    @feed = feed
    @entity = entity
  end

  # @return [Hash]
  def normalize
    raise AbstractMethodError
  end
end
