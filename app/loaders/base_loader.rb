class BaseLoader < FeedService
  # @return [FeedContent]
  def load
    raise AbstractMethodError
  end
end
