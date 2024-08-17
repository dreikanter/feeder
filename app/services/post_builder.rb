class PostBuilder
  attr_reader :feed_entity
  def initialize(feed_entity:)
    @feed_entity = feed_entity
  end

  # @return [Post]
  def build
    # TBD
  end
end
